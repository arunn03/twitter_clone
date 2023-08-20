import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/apis/realtime_api.dart';
import 'package:twitter_clone/core/enums/notiffication_type_enum.dart';
import 'package:twitter_clone/models/models.dart' as models;
import 'package:twitter_clone/core/core.dart';

class NotificationController extends StateNotifier<bool> {
  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  final NotificationAPI _notificationAPI;

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
    required BuildContext context,
  }) async {
    final notification = models.Notification(
      id: ID.unique(),
      text: text,
      postId: postId,
      uid: uid,
      notificationType: notificationType,
      createdAt: DateTime.now(),
    );
    state = true;
    final res = await _notificationAPI.createNotification(notification);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Future<List<models.Notification>> getNotifications(String uid) async {
    final documents = await _notificationAPI.getNotifications(uid);
    return documents
        .map(
          (document) => models.Notification.fromMap(document.data),
        )
        .toList();
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return NotificationController(notificationAPI: notificationAPI);
});

final notificationsProvider = FutureProvider.family((ref, String uid) {
  final notificationController = ref.watch(
    notificationControllerProvider.notifier,
  );
  return notificationController.getNotifications(uid);
});

final latestNotificationProvider = StreamProvider((ref) {
  final realtimeAPI = ref.watch(realtimeAPIProvider);
  return realtimeAPI.getStream();
});
