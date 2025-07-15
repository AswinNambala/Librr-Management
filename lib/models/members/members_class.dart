import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'members_class.g.dart';

@HiveType(typeId: 0)
class MemberClass {
  @HiveField(0)
  Uint8List? profileImage;
  @HiveField(1)
  String mFirstName;
  @HiveField(2)
  String mLastName;
  @HiveField(3)
  String mAddress;
  @HiveField(4)
  String mPincode;
  @HiveField(5)
  String mPhoneNumber;
  @HiveField(6)
  String mGender;
  @HiveField(7)
  String mPlan;
  @HiveField(8)
  String mMembersId;
  @HiveField(9)
  String mJoinDate;
  @HiveField(10)
  String mExpireDate;
  @HiveField(11)
  String mBooksPerMonth;

  MemberClass(
    this.profileImage,
    this.mFirstName,
    this.mLastName,
    this.mAddress,
    this.mPincode,
    this.mPhoneNumber,
    this.mGender,
    this.mPlan,
    this.mMembersId,
    this.mJoinDate,
    this.mExpireDate,
    this.mBooksPerMonth,
  );
}
