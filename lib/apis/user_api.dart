import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  // final realtime = ref.watch(appwriteRealtimeProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData({required UserModel user});
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData({
    required UserModel user,
    File? profilePic,
    File? coverPic,
  });
  FutureEitherVoid followUser(
    UserModel currentUser,
    UserModel user,
  );
  // Stream<RealtimeMessage> getUpdatedUser(String uid);
  // Stream<RealtimeMessage> getUpdatedUser();
}

class UserAPI implements IUserAPI {
  final Databases _db;
  // final Realtime _realtime;

  const UserAPI({
    required Databases db,
    // required Realtime realtime,
  }) : _db = db;
  // _realtime = realtime;

  @override
  FutureEitherVoid saveUserData({required UserModel user}) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.uid,
        data: user.toMap(),
      );
      return right(null);
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
  Future<Document> getUserData(String uid) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: uid,
    );
    return document;
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      queries: [
        Query.search('name', name),
      ],
    );
    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData({
    required UserModel user,
    File? profilePic,
    File? coverPic,
  }) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.uid,
        data: user.toMap(),
      );
      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(
        error.message ?? 'Something went wrong',
        stackTrace,
      ));
    }
  }

  @override
  FutureEitherVoid followUser(
    UserModel currentUser,
    UserModel user,
  ) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.uid,
        data: user.toMap(),
      );
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(
        error.message ?? 'Something went wrong',
        stackTrace,
      ));
    }
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: currentUser.uid,
        data: currentUser.toMap(),
      );
      return right(null);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(
        error.message ?? 'Something went wrong',
        stackTrace,
      ));
    }
  }

  // @override
  // Stream<RealtimeMessage> getUpdatedUser() {
  //   print('Inside getUpdateUser()');
  //   return _realtime.subscribe([
  //     'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollectionId}.documents',
  //   ]).stream;
  // }

  // @override
  // Stream<RealtimeMessage> getUpdatedUser(String uid) {
  // return _realtime.subscribe([
  //   'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollectionId}.documents.$uid',
  // ]).stream;
  // }
}
