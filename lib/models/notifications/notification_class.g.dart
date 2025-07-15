// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationClassAdapter extends TypeAdapter<NotificationClass> {
  @override
  final int typeId = 5;

  @override
  NotificationClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationClass(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationClass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.body)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
