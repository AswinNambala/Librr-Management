import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:librrr_management/data/models/notifications/notification_class.dart';
import 'package:librrr_management/core/helpers/appbar_for_all.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<NotificationClass>('notifications');

    return Scaffold(
      appBar:
          const AppBarForAll(appBarTitle: 'Notifications', navToBorrow: false),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<NotificationClass> box, _) {
          if (box.isEmpty) {
            return Center(
                child: Text(
              'No notifications',
              style: Theme.of(context).textTheme.bodyLarge,
            ));
          }

          final notifications = box.values.toList().reversed.toList();
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (box.isNotEmpty)
                    Text('${box.length} Notification', style: Theme.of(context).textTheme.bodySmall,),
                    TextButton(
                        onPressed: () {
                          box.clear();
                        },
                        child: Text(
                          'Clear All',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        color: Theme.of(context).cardTheme.color,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            notification.body,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(
                            DateFormat('dd MMM, hh:mm a')
                                .format(notification.time),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
