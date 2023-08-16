import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
// import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/models/user.dart';

class AuthControllerNotifier extends StateNotifier<bool> {
  AuthControllerNotifier({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  final AuthAPI _authAPI;
  final UserAPI _userAPI;

  // state -> isLoading
  void signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signup(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel user = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePicture: '',
          coverPicture: '',
          uid: r.$id,
          bio: '',
          isVerified: false,
        );
        state = false;
        final res2 = await _userAPI.saveUserData(user: user);
        state = true;
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) async {
            showSnackBar(context, 'Account has been created. Please login.');
            Navigator.pushReplacement(context, LoginView.route());
          },
        );
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => ref.read(currentUserProvider.notifier).setUser(),
    );
  }

  Future<User?> currentUser() async => await _authAPI.currentUser();

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    return UserModel.fromMap(document.data);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, bool>(
  (ref) {
    final authAPI = ref.watch(authAPIProvider);
    final userAPI = ref.watch(userAPIProvider);
    return AuthControllerNotifier(
      authAPI: authAPI,
      userAPI: userAPI,
    );
  },
);

final currentUserDetailsProvider = FutureProvider((ref) async {
  final currentUserId = (await ref.watch(currentUserProvider))!.$id;
  final userDetails = ref.watch(userDataProvider(currentUserId));
  return userDetails.value;
});

final userDataProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final userData = await authController.getUserData(uid);
  return userData;
});

class CurrentUserNotifier extends StateNotifier<Future<User?>> {
  CurrentUserNotifier({
    required AuthControllerNotifier authController,
  })  : _authController = authController,
        super(authController.currentUser());

  final AuthControllerNotifier _authController;

  void setUser() async {
    state = _authController.currentUser();
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, Future<User?>>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return CurrentUserNotifier(authController: authController);
});
