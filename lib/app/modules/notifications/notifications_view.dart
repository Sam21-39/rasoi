import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';
import '../../core/theme/app_theme.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Obx(
        () => ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: notif['isRead']
                    ? Colors.grey[300]
                    : AppColors.primary.withOpacity(0.2),
                child: Icon(
                  _getIcon(notif['type']),
                  color: notif['isRead'] ? Colors.grey : AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                notif['message'],
                style: TextStyle(fontWeight: notif['isRead'] ? FontWeight.normal : FontWeight.bold),
              ),
              subtitle: Text(notif['time']),
              trailing: notif['isRead']
                  ? null
                  : const CircleAvatar(radius: 4, backgroundColor: Colors.red),
              tileColor: notif['isRead'] ? null : AppColors.primary.withOpacity(0.05),
            );
          },
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'follow':
        return Icons.person_add;
      case 'like':
        return Icons.favorite;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
