import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class FollowCount extends StatelessWidget {
  const FollowCount({
    super.key,
    required this.count,
    required this.text,
  });

  final int count;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$count',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Pallete.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
