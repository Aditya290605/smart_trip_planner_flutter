import 'package:hive/hive.dart';
import 'package:smart_trip_planner/features/trip_plan/domain/entities/ltinerary_entity.dart';

part 'itinerary_hive_model.g.dart';

@HiveType(typeId: 0)
class ItineraryHiveModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String startDate;

  @HiveField(2)
  String endDate;

  @HiveField(3)
  List<ItineraryDayHiveModel> days;

  ItineraryHiveModel({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.days,
  });
}

@HiveType(typeId: 1)
class ItineraryDayHiveModel extends HiveObject {
  @HiveField(0)
  String summary;

  @HiveField(1)
  List<ItineraryItemHiveModel> items;

  ItineraryDayHiveModel({required this.summary, required this.items});
}

@HiveType(typeId: 2)
class ItineraryItemHiveModel extends HiveObject {
  @HiveField(0)
  String time;

  @HiveField(1)
  String activity;

  @HiveField(2)
  String location;

  ItineraryItemHiveModel({
    required this.time,
    required this.activity,
    required this.location,
  });
}

ItineraryHiveModel mapToHiveModel(ItineraryEntity entity) {
  return ItineraryHiveModel(
    title: entity.title,
    startDate: entity.startDate,
    endDate: entity.endDate,
    days: entity.days.map((day) {
      return ItineraryDayHiveModel(
        summary: day.summary,
        items: day.items.map((item) {
          return ItineraryItemHiveModel(
            time: item.time,
            activity: item.activity,
            location: item.location,
          );
        }).toList(),
      );
    }).toList(),
  );
}

ItineraryEntity mapToEntity(ItineraryHiveModel hiveModel) {
  return ItineraryEntity(
    title: hiveModel.title,
    startDate: hiveModel.startDate,
    endDate: hiveModel.endDate,
    days: hiveModel.days.map((day) {
      return ItineraryDayEntity(
        date: '', // Hive model does not store date
        summary: day.summary,
        items: day.items.map((item) {
          return ItineraryItemEntity(
            time: item.time,
            activity: item.activity,
            location: item.location,
          );
        }).toList(),
      );
    }).toList(),
  );
}
