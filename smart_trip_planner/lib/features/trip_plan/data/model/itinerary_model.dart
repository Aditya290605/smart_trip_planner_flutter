import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';

class ItineraryModel extends ItineraryEntity {
  ItineraryModel({
    required super.title,
    required super.startDate,
    required super.endDate,
    required List<ItineraryDayModel> days,
  }) : super(days: days);

  factory ItineraryModel.fromJson(Map<String, dynamic> json) {
    return ItineraryModel(
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      days: (json['days'] as List)
          .map((d) => ItineraryDayModel.fromJson(d))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'startDate': startDate,
      'endDate': endDate,
      'days': days.map((day) => (day as ItineraryDayModel).toJson()).toList(),
    };
  }
}

class ItineraryDayModel extends ItineraryDayEntity {
  ItineraryDayModel({
    required super.date,
    required super.summary,
    required List<ItineraryItemModel> items,
  }) : super(items: items);

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      date: json['date'],
      summary: json['summary'],
      items: (json['items'] as List)
          .map((i) => ItineraryItemModel.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'summary': summary,
      'items': items
          .map((item) => (item as ItineraryItemModel).toJson())
          .toList(),
    };
  }
}

class ItineraryItemModel extends ItineraryItemEntity {
  ItineraryItemModel({
    required super.time,
    required super.activity,
    required super.location,
  });

  factory ItineraryItemModel.fromJson(Map<String, dynamic> json) {
    return ItineraryItemModel(
      time: json['time'],
      activity: json['activity'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'activity': activity, 'location': location};
  }
}
