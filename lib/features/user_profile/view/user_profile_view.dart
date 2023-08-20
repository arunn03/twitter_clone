import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';
import 'package:twitter_clone/models/models.dart';

class UserProfileView extends ConsumerStatefulWidget {
  static route(UserModel user) => MaterialPageRoute(
        builder: (ctx) => UserProfileView(user: user),
      );
  const UserProfileView({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<UserProfileView> createState() {
    return _UserProfileViewState();
  }
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(userUpdateProvider).when(
            data: (data) {
              const updateEvent =
                  'databases.*.collections.${AppwriteConstants.usersCollectionId}.documents.*.update';
              if (data.events.contains(updateEvent)) {
                final updatedUser = UserModel.fromMap(data.payload);
                // final currentUser = ref.watch(currentUserDetailsProvider).value;
                // if (currentUser != null && updatedUser.uid == currentUser.uid) {
                //   _user = updatedUser;
                // }
                if (_user.uid == updatedUser.uid) {
                  _user = updatedUser;
                }
              }
              return UserProfile(user: _user);
            },
            error: (error, st) => ErrorText(
              text: error.toString(),
            ),
            loading: () {
              return UserProfile(user: _user);
            },
          ),
      // ,
    );
  }
}
