import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_text.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetCard extends ConsumerStatefulWidget {
  const TweetCard({super.key, required this.tweet});

  final Tweet tweet;

  @override
  ConsumerState<TweetCard> createState() {
    return _TweetCardState();
  }
}

class _TweetCardState extends ConsumerState<TweetCard> {
  void onTapLike(
    Tweet tweet,
    UserModel user,
    BuildContext context,
  ) {
    ref
        .read(tweetControllerProvider.notifier)
        .toggleTweetLike(tweet, user, context);
  }

  void onTapRetweet(
    Tweet tweet,
    UserModel user,
    BuildContext context,
  ) {
    ref
        .read(tweetControllerProvider.notifier)
        .reshareTweet(tweet, user, context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDataProvider(widget.tweet.uid)).when(
              data: (user) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                    top: 3,
                    // vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Pallete.blueColor,
                        foregroundImage: NetworkImage(user.profilePicture),
                        radius: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.tweet.retweetedBy.isNotEmpty)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsConstants.retweetIcon,
                                    color: Pallete.greyColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${widget.tweet.retweetedBy} retweeted',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Pallete.greyColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            // if (widget.tweet.retweetedBy.isEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '@${user.name} . ${timeago.format(
                                    widget.tweet.createdAt,
                                    locale: 'en_short',
                                  )}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.greyColor,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.tweet.repliedTo.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              ref
                                  .watch(
                                      tweetByIdProvider(widget.tweet.repliedTo))
                                  .when(
                                    data: (tweet) {
                                      final user = ref
                                          .watch(userDataProvider(tweet.uid))
                                          .value;
                                      return RichText(
                                        text: TextSpan(
                                          text: 'Replying to ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Pallete.greyColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '@${user?.name}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Pallete.blueColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    error: (error, st) {
                                      return ErrorText(text: error.toString());
                                    },
                                    loading: () => const Loader(),
                                  ),
                            ],
                            const SizedBox(height: 5),
                            TweetText(
                              text: widget.tweet.text,
                            ),
                            if (widget.tweet.tweetType == TweetType.image) ...[
                              const SizedBox(height: 10),
                              CarouselImage(imageLinks: widget.tweet.images),
                            ],
                            if (widget.tweet.link.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: AnyLinkPreview(
                                  link: widget.tweet.link,
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                right: 20,
                              ),
                              child: Row(
                                children: [
                                  TweetIconButton(
                                    onTap: () {},
                                    svgPath: AssetsConstants.viewsIcon,
                                    text: (widget.tweet.commentIds.length +
                                            widget.tweet.reshareCount +
                                            widget.tweet.likes.length)
                                        .toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  TweetIconButton(
                                    onTap: () {},
                                    svgPath: AssetsConstants.commentIcon,
                                    text: widget.tweet.commentIds.length
                                        .toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  TweetIconButton(
                                    onTap: () {
                                      onTapRetweet(
                                        widget.tweet,
                                        currentUser,
                                        context,
                                      );
                                    },
                                    svgPath: AssetsConstants.retweetIcon,
                                    text: widget.tweet.reshareCount.toString(),
                                  ),
                                  const SizedBox(width: 12),
                                  // TweetIconButton(
                                  //   onTap: () {},
                                  //   svgPath: AssetsConstants.likeOutlinedIcon,
                                  //   text: widget.tweet.likes.length.toString(),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      onTapLike(
                                        widget.tweet,
                                        currentUser,
                                        context,
                                      );
                                    },
                                    child: widget.tweet.likes
                                            .contains(currentUser.uid)
                                        ? SvgPicture.asset(
                                            AssetsConstants.likeFilledIcon,
                                            color: Pallete.redColor,
                                            width: 24,
                                            height: 24,
                                          )
                                        : SvgPicture.asset(
                                            AssetsConstants.likeOutlinedIcon,
                                            color: Pallete.greyColor,
                                          ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.tweet.likes.length.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: widget.tweet.likes
                                              .contains(currentUser.uid)
                                          ? Pallete.redColor
                                          : Pallete.greyColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                      Icons.share_outlined,
                                      color: Pallete.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: .1),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) {
                return ErrorText(text: error.toString());
              },
              loading: () => const Loader(),
            );
  }
}
