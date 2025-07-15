import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/repository/itinerary_repository.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/usecases/generate_itinerary_usecase.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final GenerateItineraryUseCase useCase;
  final ItineraryRepository repository;

  ItineraryBloc(this.useCase, this.repository) : super(ItineraryInitial()) {
    on<GenerateItineraryEvent>((event, emit) async {
      // Reset token usage for new request
      emit(ItineraryLoading());
      try {
        final itinerary = await useCase(
          event.userInput,
          event.previousJson,
          event.chatHistory,
        );
        emit(ItineraryLoaded(itinerary));
      } catch (e) {
        emit(ItineraryError(e.toString()));
      }
    });

    on<RefineItineraryEvent>((event, emit) async {
      emit(ItineraryLoading());

      final history = event.history
          .map((m) => {'role': m.role, 'content': m.text})
          .toList();

      try {
        final refinedJson = await useCase(
          event.userMessage,
          event.previousJson,
          history,
        );

        emit(ItineraryLoaded(refinedJson)); // ← Your entity format
      } catch (e) {
        emit(ItineraryError('Failed to refine: $e'));
      }
    });

    on<SaveItineraryOfflineEvent>((event, emit) async {
      try {
        await repository.saveItineraryOffline(event.itinerary);
        emit(ItinerarySavedOffline());
      } catch (e) {
        emit(ItinerarySaveFailed('Failed to save itinerary offline.'));
      }
    });
  }
}
