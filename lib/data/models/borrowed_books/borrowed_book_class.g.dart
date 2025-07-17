// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrowed_book_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BorrowedBookClassAdapter extends TypeAdapter<BorrowedBookClass> {
  @override
  final int typeId = 2;

  @override
  BorrowedBookClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BorrowedBookClass(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BorrowedBookClass obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.bookLanguage)
      ..writeByte(3)
      ..write(obj.memberId)
      ..writeByte(4)
      ..write(obj.memberName)
      ..writeByte(5)
      ..write(obj.borrowedDate)
      ..writeByte(6)
      ..write(obj.returnDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorrowedBookClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
