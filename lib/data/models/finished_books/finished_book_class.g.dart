// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_book_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinishedBookClassAdapter extends TypeAdapter<FinishedBookClass> {
  @override
  final int typeId = 3;

  @override
  FinishedBookClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinishedBookClass(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FinishedBookClass obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bookName)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.memberName)
      ..writeByte(4)
      ..write(obj.fineAmount)
      ..writeByte(5)
      ..write(obj.bookReturnedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishedBookClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
