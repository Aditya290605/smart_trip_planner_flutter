// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItineraryHiveModelAdapter extends TypeAdapter<ItineraryHiveModel> {
  @override
  final int typeId = 0;

  @override
  ItineraryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryHiveModel(
      title: fields[0] as String,
      startDate: fields[1] as String,
      endDate: fields[2] as String,
      days: (fields[3] as List).cast<ItineraryDayHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItineraryDayHiveModelAdapter extends TypeAdapter<ItineraryDayHiveModel> {
  @override
  final int typeId = 1;

  @override
  ItineraryDayHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryDayHiveModel(
      summary: fields[0] as String,
      items: (fields[1] as List).cast<ItineraryItemHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryDayHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.summary)
      ..writeByte(1)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryDayHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItineraryItemHiveModelAdapter
    extends TypeAdapter<ItineraryItemHiveModel> {
  @override
  final int typeId = 2;

  @override
  ItineraryItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryItemHiveModel(
      time: fields[0] as String,
      activity: fields[1] as String,
      location: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryItemHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.activity)
      ..writeByte(2)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
