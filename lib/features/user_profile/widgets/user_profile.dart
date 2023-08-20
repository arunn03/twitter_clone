import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_tweet_list.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserFuture = ref.watch(currentUserProvider);
    return FutureBuilder(
      future: currentUserFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (snapshot.hasError) {
          return ErrorText(text: snapshot.error.toString());
        }
        if (snapshot.hasData) {
          final currentUserAccount = snapshot.data;
          final currentUser = ref
              .watch(
                userDataProvider(currentUserAccount!.$id),
              )
              .value;
          // print('current user');
          // print(currentUser.toString());
          // print('user');
          // print(user.toString());
          return currentUser == null
              ? const LoadingScreen()
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        actions: [
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .logout(context: context, ref: ref);
                            },
                            icon: const Icon(Icons.logout),
                          ),
                        ],
                        expandedHeight: 150,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: user.coverPicture.isNotEmpty
                                  ? Stack(
                                      children: [
                                        Image.network(
                                          user.coverPicture,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          color: Pallete.backgroundColor
                                              .withOpacity(.5),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      color: Pallete.blueColor,
                                    ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 30,
                              child: CircleAvatar(
                                backgroundColor: Pallete.greyColor,
                                foregroundImage: user.profilePicture.isNotEmpty
                                    ? NetworkImage(user.profilePicture)
                                    : null,
                                radius: 40,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              margin: const EdgeInsets.only(
                                bottom: 30,
                                right: 30,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (currentUser.uid == user.uid) {
                                    Navigator.push(
                                      context,
                                      EditProfileView.route(user),
                                    );
                                  } else {
                                    ref
                                        .read(userProfileControllerProvider
                                            .notifier)
                                        .followUser(
                                          user: user,
                                          currentUser: currentUser,
                                          context: context,
                                        );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: const BorderSide(
                                      color: Pallete.whiteColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                ),
                                child: Text(
                                  currentUser.uid == user.uid
                                      ? 'Edit Profile'
                                      : currentUser.following.contains(user.uid)
                                          ? 'Following'
                                          : 'Follow',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Pallete.whiteColor,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '@${user.name}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Pallete.greyColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                user.bio,
                                style: const TextStyle(fontSize: 17),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  FollowCount(
                                    count: user.followers.length,
                                    text: 'Followers',
                                  ),
                                  // const SizedBox(width: 15),
                                  FollowCount(
                                    count: user.following.length,
                                    text: 'Following',
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: .4,
                                color: Pallete.greyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: UserTweetList(user: user),
                );
        }
        return const ErrorText(text: 'Something went wrong');
      },
    );
  }
}
