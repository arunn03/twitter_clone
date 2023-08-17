import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/constants/constants.dart';

import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/models.dart';

final tweetAPIprovider = Provider(
  (ref) {
    final db = ref.watch(appwriteDatabaseProvider);
    final realtime = ref.watch(appwriteRealtimeProvider);
    return TweetAPI(db: db, realtime: realtime);
  },
);

abstract class ITweetAPI {
  FutureEither<Document> shareTweet({required Tweet tweet});
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureEitherVoid toggleTweetLike(Tweet tweet);
  FutureEitherVoid updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
}

class TweetAPI implements ITweetAPI {
  const TweetAPI({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

  final Databases _db;
  final Realtime _realtime;

  @override
  FutureEither<Document> shareTweet({required Tweet tweet}) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(
        error.message ?? 'Something went wrong. Please try again',
        stackTrace,
      ));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollectionId}.documents',
    ]).stream;
  }

  @override
  FutureEitherVoid toggleTweetLike(Tweet tweet) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
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
  FutureEitherVoid updateReshareCount(Tweet tweet) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
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
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollectionId,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return documents.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollectionId,
      documentId: id,
    );
    return document;
  }
}
