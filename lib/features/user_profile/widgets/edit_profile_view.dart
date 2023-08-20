import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route(UserModel user) => MaterialPageRoute(
        builder: (ctx) => EditProfileView(user: user),
      );
  const EditProfileView({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<EditProfileView> createState() {
    return _EditProfileViewState();
  }
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  File? _coverPic;
  File? _profilePic;

  @override
  void initState() {
    super.initState();
    // final currentUser = ref.read(currentUserDetailsProvider).value;
    // print(currentUser?.coverPicture);
    _nameController = TextEditingController(
      text: widget.user.name,
    );
    _bioController = TextEditingController(
      text: widget.user.bio,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  void _pickCoverImage() async {
    final coverPic = await pickImage();
    if (coverPic == null) {
      return;
    }
    setState(() {
      _coverPic = coverPic;
    });
  }

  void _pickProfileImage() async {
    final profilePic = await pickImage();
    if (profilePic == null) {
      return;
    }
    setState(() {
      _profilePic = profilePic;
    });
  }

  void _onSave(UserModel user) {
    ref.read(userProfileControllerProvider.notifier).updateUserData(
          user: user.copyWith(
            name: _nameController.text,
            bio: _bioController.text,
          ),
          context: context,
          profilePic: _profilePic,
          coverPic: _coverPic,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final widget.user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: !isLoading
                ? () {
                    _onSave(widget.user);
                  }
                : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickCoverImage,
                          child: _coverPic != null ||
                                  widget.user.coverPicture.isNotEmpty
                              ? Stack(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: _coverPic != null
                                          ? Image.file(
                                              _coverPic!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                          : Image.network(
                                              widget.user.coverPicture,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        color: Pallete.backgroundColor
                                            .withOpacity(.5),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: 150,
                                  color: Pallete.blueColor,
                                ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: _profilePic != null
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Pallete.greyColor,
                                    foregroundImage: FileImage(_profilePic!),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Pallete.greyColor,
                                    foregroundImage:
                                        widget.user.profilePicture.isNotEmpty
                                            ? NetworkImage(
                                                widget.user.profilePicture,
                                              )
                                            : null,
                                  ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 20,
                        //   child: IconButton.outlined(
                        //     onPressed: () {},
                        //     icon: const Icon(Icons.edit),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              fontSize: 18,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            hintText: 'Bio',
                            hintStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            fillColor: Pallete.searchBarColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 4,
                          maxLength: 256,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
