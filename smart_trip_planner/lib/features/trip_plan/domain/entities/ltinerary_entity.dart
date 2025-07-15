import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_model.dart';

class ItineraryEntity {
  final String title;
  final String startDate;
  final String endDate;
  final List<ItineraryDayEntity> days;

  ItineraryEntity({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  ItineraryModel toModel() {
    return ItineraryModel(
      title: title,
      startDate: startDate,
      endDate: endDate,
      days: days.map((e) => e.toModel()).toList(),
    );
  }
}

class ItineraryDayEntity {
  final String date;
  final String summary;
  final List<ItineraryItemEntity> items;

  ItineraryDayEntity({
    required this.date,
    required this.summary,
    required this.items,
  });

  ItineraryDayModel toModel() {
    return ItineraryDayModel(
      date: date,
      summary: summary,
      items: items.map((e) => e.toModel()).toList(),
    );
  }
}

class ItineraryItemEntity {
  final String time;
  final String activity;
  final String location;

  ItineraryItemEntity({
    required this.time,
    required this.activity,
    required this.location,
  });

  ItineraryItemModel toModel() {
    return ItineraryItemModel(
      time: time,
      activity: activity,
      location: location,
    );
  }
}
