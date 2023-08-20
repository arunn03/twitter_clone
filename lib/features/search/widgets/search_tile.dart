import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              UserProfileView.route(user),
            );
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Pallete.greyColor,
            foregroundImage: user.profilePicture.isNotEmpty
                ? NetworkImage(
                    user.profilePicture,
                  )
                : null,
          ),
          title: Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '@${user.name}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Pallete.blueColor,
            ),
          ),
        ),
        const Divider(
          thickness: .5,
          color: Pallete.greyColor,
        ),
      ],
    );
    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 16,
    //         vertical: 8,
    //       ),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           CircleAvatar(
    //             radius: 30,
    //             backgroundColor: Pallete.greyColor,
    //             foregroundImage: NetworkImage(
    //               user.profilePicture,
    //             ),
    //           ),
    //           const SizedBox(width: 15),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 user.name,
    //                 style: const TextStyle(
    //                   fontSize: 18,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //               ),
    //               const SizedBox(height: 3),
    //               Text(
    //                 '@${user.name}',
    //                 style: const TextStyle(
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.bold,
    //                   color: Pallete.blueColor,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //     // const SizedBox(height: 5),
    //     const Divider(
    //       thickness: .2,
    //       color: Pallete.greyColor,
    //     ),
    //   ],
    // );
  }
}
