import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/theme/theme.dart';

class HashtagTweetsView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (ctx) => HashtagTweetsView(hashtag: hashtag),
      );
  const HashtagTweetsView({super.key, required this.hashtag});

  final String hashtag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Divider(
            height: .2,
            thickness: .2,
            color: Pallete.greyColor,
          ),
        ),
      ),
      body: ref.watch(hashtagTweetsProvider(hashtag)).when(
            data: (tweets) {
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
                        const Divider(thickness: .2, color: Pallete.greyColor),
                      ],
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(text: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
