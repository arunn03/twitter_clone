import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/notiffication_type_enum.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/models/models.dart' as models;

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final models.Notification notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.blueColor,
              size: 30,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  color: Pallete.redColor,
                  width: 30,
                  height: 30,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      color: Pallete.whiteColor,
                      width: 30,
                      height: 30,
                    )
                  : SvgPicture.asset(
                      AssetsConstants.commentIcon,
                      color: Pallete.whiteColor,
                      width: 30,
                      height: 30,
                    ),
      title: RichText(
        text: TextSpan(
          text: '${notification.text} ',
          children: [
            TextSpan(
              text: '. ${timeago.format(
                notification.createdAt,
                locale: 'en_short',
              )}',
            ),
          ],
        ),
      ),
    );
  }
}
