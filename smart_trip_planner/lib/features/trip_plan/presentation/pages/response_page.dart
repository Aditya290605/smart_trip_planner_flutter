import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/core/utils/userdata.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_button.dart';
import 'package:smart_trip_planner/features/trip_plan/data/repository/tokens_limit.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_state.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/chat_page.dart';

import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/error_dailog.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/loader.dart';
import 'package:url_launcher/url_launcher.dart';

class ItineraryCreatedScreen extends StatefulWidget {
  final String initialPrompt;
  final ItineraryEntity? offlineEntity;

  const ItineraryCreatedScreen({
    super.key,
    required this.initialPrompt,
    this.offlineEntity,
  });

  @override
  State<ItineraryCreatedScreen> createState() => _ItineraryCreatedScreenState();
}

class _ItineraryCreatedScreenState extends State<ItineraryCreatedScreen> {
  ItineraryEntity? initialResponse;

  @override
  Widget build(BuildContext context) {
    final userInitial = context.watch<UserProvider>().userName;
    // If offlineEntity is provided, always show it
    if (widget.offlineEntity != null) {
      final itinerary = widget.offlineEntity!;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Offline Itinerary',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          itinerary.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('🏝️', style: TextStyle(fontSize: 26)),
                    ],
                  ),
                ),
                SizedBox(height: 32),
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
                  child: _buildOfflineCardContent(itinerary),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    }
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
                userInitial.isNotEmpty ? userInitial[0].toUpperCase() : '?',
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
      body: BlocBuilder<ItineraryBloc, ItineraryState>(
        builder: (context, state) {
          final isLoaded = state is ItineraryLoaded;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  SizedBox(height: 20),

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

                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.55,
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
                    child: _buildCardContent(state),
                  ),

                  SizedBox(height: 28),

                  PrimaryButton(
                    label: 'Follow up to refine',
                    onPressed: isLoaded
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TravelChatScreen(
                                  initialPrompt: widget.initialPrompt,
                                  initialResponse: initialResponse!,
                                ),
                              ),
                            );
                          }
                        : () {},
                  ),
                  SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoaded
                          ? () {
                              context.read<ItineraryBloc>().add(
                                SaveItineraryOfflineEvent(
                                  itinerary: state.itinerary,
                                ),
                              );
                            }
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isLoaded ? Colors.black : Colors.grey,
                        side: BorderSide(
                          color: isLoaded
                              ? Colors.grey[300]!
                              : Colors.grey[200]!,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.download,
                            size: 20,
                            color: isLoaded ? Colors.black : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Save Offline',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isLoaded ? Colors.black : Colors.grey,
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
          );
        },
      ),
    );
  }

  Widget _buildCardContent(ItineraryState state) {
    if (state is ItineraryLoading) {
      return const Center(
        child: CustomLoader(message: 'Curating a perfect plan for you...'),
      );
    } else if (state is ItineraryError) {
      return ErrorDialog();
    } else if (state is ItineraryLoaded) {
      GeminiUsageTracker().track(
        prompt: widget.initialPrompt,
        response: state.itinerary.toString(),
      );

      initialResponse = state.itinerary;

      if (state.itinerary.days.isEmpty) {
        return const Center(child: Text('No days found in this itinerary.'));
      }
      final day = state.itinerary.days.first;
      final summary = day.summary;
      final title = state.itinerary.title;
      final items = day.items;

      return SingleChildScrollView(
        child: Column(
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
            if (items.isEmpty) const Text('No activities found for this day.'),
            ...items.map(
              (item) => _buildBulletPoint('${item.time}: ${item.activity}'),
            ),

            const SizedBox(height: 20),

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
                    Icon(Icons.location_on, color: Colors.blue, size: 16),
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

            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildOfflineCardContent(ItineraryEntity itinerary) {
    final day = itinerary.days.isNotEmpty ? itinerary.days.first : null;
    final summary = day?.summary ?? '';
    final title = itinerary.title;
    final items = day?.items ?? [];
    return SingleChildScrollView(
      child: Column(
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
          ...items.map(
            (item) => _buildBulletPoint('${item.time}: ${item.activity}'),
          ),
          const SizedBox(height: 20),
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
                  Icon(Icons.location_on, color: Colors.blue, size: 16),
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
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        ],
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
