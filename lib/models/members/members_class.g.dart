// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberClassAdapter extends TypeAdapter<MemberClass> {
  @override
  final int typeId = 0;

  @override
  MemberClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberClass(
      fields[0] as Uint8List?,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemberClass obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.profileImage)
      ..writeByte(1)
      ..write(obj.mFirstName)
      ..writeByte(2)
      ..write(obj.mLastName)
      ..writeByte(3)
      ..write(obj.mAddress)
      ..writeByte(4)
      ..write(obj.mPincode)
      ..writeByte(5)
      ..write(obj.mPhoneNumber)
      ..writeByte(6)
      ..write(obj.mGender)
      ..writeByte(7)
      ..write(obj.mPlan)
      ..writeByte(8)
      ..write(obj.mMembersId)
      ..writeByte(9)
      ..write(obj.mJoinDate)
      ..writeByte(10)
      ..write(obj.mExpireDate)
      ..writeByte(11)
      ..write(obj.mBooksPerMonth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
