import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/repository/itinerary_repository.dart';

class GenerateItineraryUseCase {
  final ItineraryRepository repository;

  GenerateItineraryUseCase(this.repository);

  Future<ItineraryEntity> call(
    String userInput,
    String previousJson,
    List<Map<String, String?>> chatHistory,
  ) {
    return repository.generateItinerary(userInput, previousJson, chatHistory);
  }
}
