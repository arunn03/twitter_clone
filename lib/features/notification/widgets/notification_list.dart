import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/features/notification/widgets/notification_card.dart';
import 'package:twitter_clone/models/models.dart' as models;
import 'package:twitter_clone/theme/theme.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({super.key});

  @override
  ConsumerState<NotificationList> createState() {
    return _NotificationListState();
  }
}

class _NotificationListState extends ConsumerState<NotificationList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : ref.watch(notificationsProvider(currentUser.uid)).when(
              data: (notifications) {
                return ref.watch(latestNotificationProvider).when(
                  data: (data) {
                    const createEvent =
                        'databases.*.collections.${AppwriteConstants.notCollectionId}.documents.*.create';
                    if (data.events.contains(createEvent)) {
                      var payload = models.Notification.fromMap(data.payload);
                      if (data.events.contains(createEvent) &&
                          !notifications.contains(payload)) {
                        if (payload.uid == currentUser.uid) {
                          notifications.insert(0, payload);
                        }
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NotificationCard(
                                notification: notifications[index],
                              ),
                              const Divider(
                                  thickness: .2, color: Pallete.greyColor),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(text: error.toString());
                  },
                  loading: () {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              NotificationCard(
                                notification: notifications[index],
                              ),
                              const Divider(
                                  thickness: .2, color: Pallete.greyColor),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
              error: (error, st) => ErrorText(text: error.toString()),
              loading: () => const Loader(),
            );
  }
}
