// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_book_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestBookClassAdapter extends TypeAdapter<RequestBookClass> {
  @override
  final int typeId = 4;

  @override
  RequestBookClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestBookClass(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RequestBookClass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rBookName)
      ..writeByte(1)
      ..write(obj.rAuthorName)
      ..writeByte(2)
      ..write(obj.rLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestBookClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
