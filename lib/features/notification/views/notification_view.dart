import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/notification/widgets/notification_list.dart';
import 'package:twitter_clone/theme/theme.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        // elevation: 10,
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Divider(
            height: .2,
            thickness: .2,
            color: Pallete.greyColor,
          ),
        ),
      ),
      body: const NotificationList(),
    );
  }
}
