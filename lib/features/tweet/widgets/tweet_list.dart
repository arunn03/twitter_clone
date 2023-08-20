import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetList extends ConsumerStatefulWidget {
  const TweetList({super.key});

  @override
  ConsumerState<TweetList> createState() {
    return _TweetListState();
  }
}

class _TweetListState extends ConsumerState<TweetList> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(tweetsProvider).when(
          data: (tweets) {
            return ref.watch(latestTweetProvider).when(
              data: (data) {
                const createEvent =
                    'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create';
                const updateEvent =
                    'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update';
                if (data.events.contains(createEvent) ||
                    data.events.contains(updateEvent)) {
                  var payload = Tweet.fromMap(data.payload);
                  if (data.events.contains(createEvent) &&
                      !tweets.contains(payload)) {
                    tweets.insert(0, payload);
                  } else if (data.events.contains(updateEvent)) {
                    var tweetId = payload.id;
                    var tweet = tweets.where((e) => e.id == tweetId).first;
                    final index = tweets.indexOf(tweet);
                    tweets.removeWhere((e) => e.id == tweetId);
                    tweets.insert(index, payload);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                TweetReplyView.route(tweets[index]),
                              );
                            },
                            child: TweetCard(tweet: tweets[index]),
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
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                TweetReplyView.route(tweets[index]),
                              );
                            },
                            child: TweetCard(tweet: tweets[index]),
                          ),
                          const Divider(
                              thickness: .3, color: Pallete.greyColor),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorText(text: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
