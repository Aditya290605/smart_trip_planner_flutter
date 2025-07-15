// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_button.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_state.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/chat_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ItineraryCreatedScreen extends StatefulWidget {
  final String initialPrompt;

  const ItineraryCreatedScreen({super.key, required this.initialPrompt});

  @override
  State<ItineraryCreatedScreen> createState() => _ItineraryCreatedScreenState();
}

class _ItineraryCreatedScreenState extends State<ItineraryCreatedScreen> {
  ItineraryEntity? initialResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              radius: 18,
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Centered title
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Itinerary Created',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('🏝️', style: TextStyle(fontSize: 26)),
                  ],
                ),
              ),
              SizedBox(height: 32),
              // Main itinerary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BlocBuilder<ItineraryBloc, ItineraryState>(
                  builder: (context, state) {
                    if (state is ItineraryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ItineraryError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is ItineraryLoaded) {
                      initialResponse = state.itinerary;

                      final day = state.itinerary.days.first;
                      final summary = day.summary;
                      final title = state.itinerary.title;
                      final items = day.items;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day 1: $summary',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ▪️ Dynamic bullet points
                          ...items.map(
                            (item) => _buildBulletPoint(
                              '${item.time}: ${item.activity}',
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ▪️ Open in Maps (uses the first location in the list)
                          if (items.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                final loc = items.first.location;
                                final mapUrl =
                                    'https://www.google.com/maps/search/?api=1&query=$loc';
                                launchUrl(Uri.parse(mapUrl));
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Open in maps',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 16),

                          // ▪️ Optional trip title (or any fixed detail)
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      );
                    }

                    // Initial state (e.g., before any search)
                    return const SizedBox();
                  },
                ),
              ),

              SizedBox(height: 28),
              // Follow up button
              PrimaryButton(
                label: 'Follow up to refine',

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TravelChatScreen(
                        initialPrompt: widget.initialPrompt,
                        initialResponse: initialResponse!,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              // Save offline button
              Container(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Save offline functionality
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 20, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        'Save Offline',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 9, right: 12),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
