import 'package:hive_flutter/adapters.dart';
    part 'request_book_class.g.dart';

@HiveType(typeId: 4)
class RequestBookClass {
  @HiveField(0)
  String rBookName;
  @HiveField(1)
  String rAuthorName;
  @HiveField(2)
  String rLanguage;
  RequestBookClass(this.rBookName, this.rAuthorName, this.rLanguage);
}
