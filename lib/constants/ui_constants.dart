import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/notification/views/notification_view.dart';
import 'package:twitter_clone/features/search/view/search_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart';

class UIConstants {
  static AppBar appBar({void Function()? onTap}) {
    return AppBar(
      actions: onTap != null
          ? [
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.logout),
              ),
            ]
          : null,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
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
    );
  }

  static const List<Widget> bottomtabPages = [
    TweetList(),
    SearchView(),
    NotificationView(),
    // UserProfileView(user: user),
  ];
}
