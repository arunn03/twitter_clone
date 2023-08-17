import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetsProvider).when(
          data: (tweets) => ref.watch(latestTweetProvider).when(
            data: (data) {
              var payload = Tweet.fromMap(data.payload);
              if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create',
                  ) &&
                  !tweets.contains(payload)) {
                tweets.insert(0, payload);
              } else if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update',
              )) {
                var tweetId = payload.id;
                var tweet = tweets.where((e) => e.id == tweetId).first;
                final index = tweets.indexOf(tweet);
                tweets.removeWhere((e) => e.id == tweetId);
                tweets.insert(index, payload);
              }
              return ListView.builder(
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
                      const Divider(thickness: .2, color: Pallete.greyColor),
                    ],
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return ErrorText(text: error.toString());
            },
            loading: () {
              return ListView.builder(
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
                      const Divider(thickness: .3, color: Pallete.greyColor),
                    ],
                  );
                },
              );
            },
          ),
          error: (error, stackTrace) {
            return ErrorText(text: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
