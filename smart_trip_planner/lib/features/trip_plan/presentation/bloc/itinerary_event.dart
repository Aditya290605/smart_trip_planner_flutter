import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/chat_page.dart';

abstract class ItineraryEvent {}

class GenerateItineraryEvent extends ItineraryEvent {
  final String userInput;
  final String previousJson;
  final List<Map<String, String>> chatHistory;

  GenerateItineraryEvent({
    required this.userInput,
    required this.previousJson,
    required this.chatHistory,
  });
}

class RefineItineraryEvent extends ItineraryEvent {
  final List<ChatMessage> history;
  final String userMessage;
  final String previousJson;

  RefineItineraryEvent({
    required this.history,
    required this.userMessage,
    required this.previousJson,
  });
}

class SaveItineraryOfflineEvent extends ItineraryEvent {
  final ItineraryEntity itinerary;

  SaveItineraryOfflineEvent({required this.itinerary});
}
