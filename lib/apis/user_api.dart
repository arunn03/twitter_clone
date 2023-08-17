import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData({required UserModel user});
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
}

class UserAPI implements IUserAPI {
  final Databases _db;

  const UserAPI({required Databases db}) : _db = db;

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
}
