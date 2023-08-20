import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/models/models.dart';

class UserTweetList extends ConsumerWidget {
  const UserTweetList({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userTweetsProvider(user.uid)).when(
          data: (tweets) {
            return ref.watch(latestTweetProvider).when(
                  data: (data2) {
                    const createEvent =
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create';
                    const updateEvent =
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update';
                    if (data2.events.contains(createEvent) ||
                        data2.events.contains(updateEvent)) {
                      var payload = Tweet.fromMap(data2.payload);
                      if (payload.uid == user.uid) {
                        if (data2.events.contains(createEvent) &&
                            !tweets.contains(payload)) {
                          tweets.insert(0, payload);
                        } else if (data2.events.contains(updateEvent)) {
                          var tweetId = payload.id;
                          var tweet =
                              tweets.where((e) => e.id == tweetId).first;
                          final index = tweets.indexOf(tweet);
                          tweets.removeWhere((e) => e.id == tweetId);
                          tweets.insert(index, payload);
                        }
                      }
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              TweetReplyView.route(tweets[index]),
                            );
                          },
                          child: TweetCard(tweet: tweets[index]),
                        );
                      },
                    );
                  },
                  error: (error, st) {
                    return ErrorText(text: error.toString());
                  },
                  loading: () => ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            TweetReplyView.route(tweets[index]),
                          );
                        },
                        child: TweetCard(tweet: tweets[index]),
                      );
                    },
                  ),
                );
          },
          error: (error, st) {
            return ErrorText(text: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
