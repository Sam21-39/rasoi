import 'package:get/get.dart';

class NotificationsController extends GetxController {
  // Mock notifications for now
  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'follow',
      'message': 'Chef Ramsay started following you',
      'time': '2m ago',
      'isRead': false,
    },
    {
      'type': 'like',
      'message': 'Jamie liked your "Butter Chicken" recipe',
      'time': '1h ago',
      'isRead': true,
    },
    {'type': 'system', 'message': 'Welcome to Rasoi Premium!', 'time': '1d ago', 'isRead': true},
  ].obs;
}
