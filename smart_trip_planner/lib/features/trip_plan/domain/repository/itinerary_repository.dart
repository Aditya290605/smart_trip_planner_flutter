import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';

abstract class ItineraryRepository {
  Future<ItineraryEntity> generateItinerary(
    String userInput,
    String previousJson,
    List<Map<String, String?>> chatHistory,
  );
}
