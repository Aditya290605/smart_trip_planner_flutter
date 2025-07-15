import 'package:smart_trip_planner/core/utils/prompt_builder.dart';
import 'package:smart_trip_planner/features/trip_plan/data/datasource/trip_remote_datasource.dart';
import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_model.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/repository/itinerary_repository.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final TripRemoteDatasource remoteDataSource;

  ItineraryRepositoryImpl(this.remoteDataSource);

  @override
  Future<ItineraryEntity> generateItinerary(
    String userInput,
    String previousJson,
    List<Map<String, String?>> chatHistory,
  ) async {
    final prompt = PromptBuilder.build(
      userRequest: userInput,
      previousJson: previousJson,
      chatHistory: chatHistory,
    );
    final json = await remoteDataSource.callGeminiAPI(prompt);
    return ItineraryModel.fromJson(json);
  }
}
