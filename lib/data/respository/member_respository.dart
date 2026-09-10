import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/members/members_class.dart';

class MembersRepository {
  MembersRepository(this.box);
  final Box<MemberClass> box;

  List<MemberClass> getAll() => box.values.toList();
  Stream<BoxEvent> watch() => box.watch();

  MemberClass? findById(String memberId) {
    final match = box.values.where((m) => m.mMembersId == memberId).toList();
    return match.isEmpty ? null : match.first;
  }

  int booksPerMonthFor(String memberId) {
    final member = findById(memberId);
    if (member == null) return 0;
    return int.tryParse(member.mBooksPerMonth) ?? 0;
  }

  Future<void> add(MemberClass member) => box.add(member);

  Future<void> update(MemberClass original, MemberClass edited) async {
    original
      ..profileImage = edited.profileImage
      ..mFirstName = edited.mFirstName
      ..mLastName = edited.mLastName
      ..mAddress = edited.mAddress
      ..mPincode = edited.mPincode
      ..mPhoneNumber = edited.mPhoneNumber
      ..mGender = edited.mGender
      ..mPlan = edited.mPlan
      ..mMembersId = edited.mMembersId
      ..mJoinDate = edited.mJoinDate
      ..mExpireDate = edited.mExpireDate
      ..mBooksPerMonth = edited.mBooksPerMonth;
    await original.save();
  }

  Future<void> updateImage(MemberClass member, Uint8List? image) async {
    member.profileImage = image;
    await member.save();
  }

  Future<void> delete(MemberClass member) => member.delete();
}