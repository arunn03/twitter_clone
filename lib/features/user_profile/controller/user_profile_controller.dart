import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/realtime_api.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/notiffication_type_enum.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/core/core.dart';

class UserProfileController extends StateNotifier<bool> {
  UserProfileController({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;

  Future<List<Tweet>> getUserTweets(String uid) async {
    final documents = await _tweetAPI.getUserTweets(uid);
    final userTweets = documents
        .map(
          (document) => Tweet.fromMap(document.data),
        )
        .toList();
    return userTweets;
  }

  void updateUserData({
    required UserModel user,
    required BuildContext context,
    required File? profilePic,
    required File? coverPic,
  }) async {
    state = true;
    if (user.profilePicture.isNotEmpty && profilePic != null) {
      await _storageAPI.deleteImage(
        AppwriteConstants.imageIdFromURL(user.profilePicture),
      );
    }
    if (user.coverPicture.isNotEmpty && coverPic != null) {
      await _storageAPI.deleteImage(
        AppwriteConstants.imageIdFromURL(user.coverPicture),
      );
    }
    if (profilePic != null && coverPic != null) {
      final imageLinks = await _storageAPI.uploadImages(
        [profilePic, coverPic],
      );
      user = user.copyWith(
        profilePicture: imageLinks[0],
        coverPicture: imageLinks[1],
      );
    } else if (coverPic != null) {
      final imageLinks = await _storageAPI.uploadImages(
        [coverPic],
      );
      user = user.copyWith(
        coverPicture: imageLinks[0],
      );
    } else if (profilePic != null) {
      final imageLinks = await _storageAPI.uploadImages(
        [profilePic],
      );
      user = user.copyWith(
        profilePicture: imageLinks[0],
      );
    }
    final res = await _userAPI.updateUserData(user: user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Profile updated!');
        Navigator.pop(context);
      },
    );
  }

  void followUser({
    required UserModel user,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    if (currentUser.following.contains(user.uid)) {
      currentUser.following.remove(user.uid);
    } else {
      currentUser.following.add(user.uid);
    }
    if (user.followers.contains(currentUser.uid)) {
      user.followers.remove(currentUser.uid);
    } else {
      user.followers.add(currentUser.uid);
    }
    final res = await _userAPI.followUser(currentUser, user);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (user.followers.contains(currentUser.uid)) {
        _notificationController.createNotification(
          text: '${currentUser.name} is now following you',
          postId: '',
          notificationType: NotificationType.follow,
          uid: user.uid,
          context: context,
        );
      }
    });
  }
}

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final tweetAPI = ref.watch(tweetAPIprovider);
    final storageAPI = ref.watch(storageAPIProvider);
    final userAPI = ref.watch(userAPIProvider);
    final notificationController =
        ref.watch(notificationControllerProvider.notifier);
    return UserProfileController(
      tweetAPI: tweetAPI,
      storageAPI: storageAPI,
      userAPI: userAPI,
      notificationController: notificationController,
    );
  },
);

final userTweetsProvider = FutureProvider.family((ref, String uid) {
  final userProfileController = ref.watch(
    userProfileControllerProvider.notifier,
  );
  return userProfileController.getUserTweets(uid);
});

final userUpdateProvider = StreamProvider((ref) {
  final realtimeAPI = ref.watch(realtimeAPIProvider);
  return realtimeAPI.getStream();
});
