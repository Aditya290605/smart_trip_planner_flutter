import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_button.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/chat_page.dart';

class ItineraryCreatedScreen extends StatelessWidget {
  const ItineraryCreatedScreen({super.key});

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
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day 1: Arrival in Bali & Settle in Ubud',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildBulletPoint(
                      'Morning: Arrive in Bali, Denpasar Airport.',
                    ),
                    _buildBulletPoint(
                      'Transfer: Private driver to Ubud (around 1.5 hours).',
                    ),
                    _buildBulletPoint(
                      'Accommodation: Check-in at a peaceful boutique hotel or villa in Ubud (e.g., Ubud Aura Retreat).',
                    ),
                    _buildBulletPoint(
                      'Afternoon: Explore Ubud\'s local area, walk around the tranquil rice terraces at Tegallalang.',
                    ),
                    _buildBulletPoint(
                      'Evening: Dinner at Locavore (known for farm-to-table dishes in peaceful environment)',
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Open in maps functionality
                      },
                      child: Row(
                        children: [
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
                    SizedBox(height: 16),
                    Text(
                      'Mumbai to Bali, Indonesia • 11hrs 5mins',
                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),
              // Follow up button
              PrimaryButton(
                label: 'Follow up to refine',

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TravelChatScreen()),
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
