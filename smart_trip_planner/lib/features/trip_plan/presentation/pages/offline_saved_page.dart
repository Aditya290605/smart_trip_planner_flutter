import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_hive_model.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';

import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/itineries_card.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/response_page.dart';

class OfflineSavedPage extends StatelessWidget {
  const OfflineSavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Saved Itineraries'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<ItineraryHiveModel>(
            'itineraries',
          ).listenable(),
          builder: (context, Box<ItineraryHiveModel> box, _) {
            final itineraries = box.values.toList();
            if (itineraries.isEmpty) {
              return const Center(
                child: Text(
                  'No offline itineraries found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.separated(
              itemCount: itineraries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final itinerary = itineraries[index];
                return GestureDetector(
                  onTap: () {
                    ItineraryEntity entity;
                    try {
                      entity = mapToEntity(itinerary);
                    } catch (_) {
                      entity = ItineraryEntity(
                        title: itinerary.title,
                        startDate: '',
                        endDate: '',
                        days: [],
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItineraryCreatedScreen(
                          initialPrompt: entity.title,
                          offlineEntity: entity,
                        ),
                      ),
                    );
                  },
                  child: ItineriesCard(title: itinerary.title),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
