import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/features/tweet/view/hashtag_tweet_view.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetText extends StatelessWidget {
  const TweetText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> tweetTextSpans = [];
    for (final word in text.split(' ')) {
      if (word.startsWith("#")) {
        tweetTextSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Pallete.blueColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  HashtagTweetsView.route(word),
                );
              },
          ),
        );
      } else if (word.startsWith('www.') ||
          word.startsWith('https://') ||
          word.startsWith('http://')) {
        tweetTextSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              fontSize: 18,
              color: Pallete.blueColor,
            ),
          ),
        );
      } else {
        tweetTextSpans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      }
    }
    return RichText(
      text: TextSpan(children: tweetTextSpans),
    );
  }
}
