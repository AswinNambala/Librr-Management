import 'package:hive/hive.dart';
import 'package:librrr_management/data/models/members/members_class.dart';

class MembersRepository {
  MembersRepository(this.box);
  final Box<MemberClass> box;

  MemberClass? findById(String memberId) {
    final match =
        box.values.where((m) => m.mMembersId == memberId).toList();
    return match.isEmpty ? null : match.first;
  }
  int booksPerMonthFor(String memberId) {
    final member = findById(memberId);
    if (member == null) return 0;
    return int.tryParse(member.mBooksPerMonth) ?? 0;
  }
}