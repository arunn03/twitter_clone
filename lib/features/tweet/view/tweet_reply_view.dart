import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetReplyView extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (ctx) => TweetReplyView(tweet: tweet),
      );
  const TweetReplyView({super.key, required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweetCard(tweet: tweet),
          ref.watch(repliesToTweetProvider(tweet)).when(
                data: (tweets) => ref.watch(latestTweetProvider).when(
                  data: (data) {
                    const createEvent =
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.create';
                    const updateEvent =
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionId}.documents.*.update';
                    if (data.events.contains(createEvent) ||
                        data.events.contains(updateEvent)) {
                      var payload = Tweet.fromMap(data.payload);
                      if (payload.repliedTo == tweet.id) {
                        if (data.events.contains(createEvent) &&
                            !tweets.contains(payload)) {
                          tweets.insert(0, payload);
                        } else if (data.events.contains(updateEvent)) {
                          var tweetId = payload.id;
                          var tweet =
                              tweets.where((e) => e.id == tweetId).first;
                          final index = tweets.indexOf(tweet);
                          tweets.removeWhere((e) => e.id == tweetId);
                          tweets.insert(index, payload);
                        }
                      }
                    }
                    return Expanded(
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
                  error: (error, stackTrace) {
                    return ErrorText(text: error.toString());
                  },
                  loading: () {
                    return Expanded(
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
                ),
                error: (error, stackTrace) {
                  return ErrorText(text: error.toString());
                },
                loading: () => const Loader(),
              ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: TextField(
              onSubmitted: (value) {
                ref.read(tweetControllerProvider.notifier).shareTweet(
                      text: value,
                      images: const [],
                      context: context,
                      repliedTo: tweet.id,
                      repliedToUserId: tweet.uid,
                    );
              },
              decoration: const InputDecoration(
                hintText: 'Reply to tweet here',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
