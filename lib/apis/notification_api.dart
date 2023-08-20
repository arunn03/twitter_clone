import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
}

class NotificationAPI implements INotificationAPI {
  const NotificationAPI({required Databases db}) : _db = db;

  final Databases _db;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
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
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notCollectionId,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }
}

final notificationAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return NotificationAPI(db: db);
});
