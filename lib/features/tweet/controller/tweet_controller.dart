import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/realtime_api.dart';

import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/core/enums/notiffication_type_enum.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/apis/storage_api.dart';

class TweetController extends StateNotifier<bool> {
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;

  void shareTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter some text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        text: text,
        images: images,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  Future<List<Tweet>> getTweets() async {
    final documents = await _tweetAPI.getTweets();
    final tweets = documents
        .map(
          (document) => Tweet.fromMap(document.data),
        )
        .toList();
    return tweets;
  }

  void toggleTweetLike(
    Tweet tweet,
    UserModel user,
    BuildContext context,
  ) async {
    List<String> likes = tweet.likes;

    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.toggleTweetLike(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (likes.contains(user.uid)) {
        _notificationController.createNotification(
          text: '${user.name} liked your tweet',
          postId: tweet.id,
          notificationType: NotificationType.like,
          uid: tweet.uid,
          context: context,
        );
      }
    });
  }

  void _shareImageTweet({
    required String text,
    required List<File> images,
    required BuildContext context,
    required String repliedTo,
  }) async {
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImages(images);
    final tweet = Tweet(
      id: '',
      text: text,
      link: _getLinkFromText(text),
      hashtags: _getHashtagsFromText(text),
      images: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    state = true;
    final res = await _tweetAPI.shareTweet(tweet: tweet);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Tweet posted successfully');
        Navigator.pop(context);
      },
    );
  }

  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      reshareCount: tweet.reshareCount + 1,
    );
    // state = true;
    final res = await _tweetAPI.updateReshareCount(tweet);
    // state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        tweet = tweet.copyWith(
          id: ID.unique(),
          likes: [],
          commentIds: [],
          reshareCount: 0,
          retweetedBy: currentUser.name,
          createdAt: DateTime.now(),
        );
        state = true;
        final res2 = await _tweetAPI.shareTweet(tweet: tweet);
        state = false;
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} retweeted your tweet',
              postId: tweet.id,
              notificationType: NotificationType.retweet,
              uid: tweet.uid,
              context: context,
            );
            showSnackBar(context, 'Retweeted!');
          },
        );
      },
    );
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    final user = _ref.read(currentUserDetailsProvider).value!;
    final tweet = Tweet(
      id: '',
      text: text,
      link: _getLinkFromText(text),
      hashtags: _getHashtagsFromText(text),
      images: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    state = true;
    final repliedToTweet = _ref.watch(tweetByIdProvider(repliedTo)).value;
    final res = await _tweetAPI.shareTweet(tweet: tweet);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        showSnackBar(context, 'Tweet posted successfully');
        if (repliedTo.isNotEmpty) {
          _notificationController.createNotification(
            text: '${user.name} replied to your tweet',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
            context: context,
          );
        }
        Navigator.pop(context);
        if (repliedToTweet != null) {
          repliedToTweet.commentIds.add(r.$id);
          await _tweetAPI.updateCommentIds(repliedToTweet);
        }
      },
    );
  }

  String _getLinkFromText(String text) {
    List<String> words = text.split(' ');
    String link = '';
    for (final word in words) {
      if (word.startsWith('https://') ||
          word.startsWith('http://') ||
          word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> words = text.split(' ');
    List<String> hashtags = [];
    for (final word in words) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    final tweets = documents
        .map(
          (document) => Tweet.fromMap(document.data),
        )
        .toList();
    return tweets;
  }

  Future<Tweet> getTweetById(String id) async {
    final document = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(document.data);
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final documents = await _tweetAPI.getTweetsByHashtag(hashtag);
    return documents
        .map(
          (document) => Tweet.fromMap(document.data),
        )
        .toList();
  }
}

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIprovider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController: ref.watch(
        notificationControllerProvider.notifier,
      ),
    );
  },
);

final tweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final latestTweetProvider = StreamProvider((ref) {
  final realtimeAPI = ref.watch(realtimeAPIProvider);
  return realtimeAPI.getStream();
});

final repliesToTweetProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final tweetByIdProvider = FutureProvider.family((ref, String id) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

final hashtagTweetsProvider = FutureProvider.family((ref, String hashtag) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag);
});
