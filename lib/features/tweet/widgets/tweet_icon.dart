import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  const TweetIconButton({
    super.key,
    required this.onTap,
    required this.svgPath,
    required this.text,
  });

  final void Function() onTap;
  final String svgPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            color: Pallete.greyColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
