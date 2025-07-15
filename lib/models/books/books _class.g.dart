// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books _class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BooksClassAdapter extends TypeAdapter<BooksClass> {
  @override
  final int typeId = 1;

  @override
  BooksClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BooksClass(
      fields[0] as Uint8List?,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BooksClass obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.imageBook)
      ..writeByte(1)
      ..write(obj.booksName)
      ..writeByte(2)
      ..write(obj.authorName)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.numberOfBooks)
      ..writeByte(5)
      ..write(obj.booksGenre)
      ..writeByte(6)
      ..write(obj.booksPrice)
      ..writeByte(7)
      ..write(obj.bookShelf);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooksClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
