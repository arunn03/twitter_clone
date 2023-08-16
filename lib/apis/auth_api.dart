import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/core/core.dart';

// final accountProvider = Provider((ref) );

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

abstract class IAuthAPI {
  FutureEither<User> signup({
    required String email,
    required String password,
  });

  FutureEither<Session> login({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;

  AuthAPI({required Account account}) : _account = account;

  Future<User?> currentUser() async {
    try {
      return await _account.get();
    } catch (error) {
      return null;
    }
  }

  @override
  FutureEither<User> signup({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(), // generates unique value
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (error, stackTrace) {
      return left(
        Failure(
          error.message ?? 'Something went wrong',
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (error, stackTrace) {
      return left(
        Failure(
          error.message ?? 'Something went wrong',
          stackTrace,
        ),
      );
    }
  }
}
