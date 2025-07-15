import 'package:hive_flutter/adapters.dart';
part 'notification_class.g.dart';
@HiveType(typeId: 5)
class NotificationClass {
  @HiveField(0)
  String body;
  @HiveField(1)
  String title;
  @HiveField(2)
  DateTime time;

  NotificationClass(this.body, this.title, this.time);
}
