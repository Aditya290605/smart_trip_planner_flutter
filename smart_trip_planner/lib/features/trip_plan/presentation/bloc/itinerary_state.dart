import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';

abstract class ItineraryState {}

class ItineraryInitial extends ItineraryState {}

class ItineraryLoading extends ItineraryState {}

class ItineraryLoaded extends ItineraryState {
  final ItineraryEntity itinerary;
  ItineraryLoaded(this.itinerary);
}

class ItineraryError extends ItineraryState {
  final String message;
  ItineraryError(this.message);
}

class ItinerarySavedOffline extends ItineraryState {}

class ItinerarySaveFailed extends ItineraryState {
  final String message;
  ItinerarySaveFailed(this.message);
}
