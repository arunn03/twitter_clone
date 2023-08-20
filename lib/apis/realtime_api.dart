import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';

abstract class IRealtimeAPI {
  Stream<RealtimeMessage> getStream();
}

class RealtimeAPI implements IRealtimeAPI {
  const RealtimeAPI({required Realtime realtime}) : _realtime = realtime;

  final Realtime _realtime;

  @override
  Stream<RealtimeMessage> getStream() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollectionId}.documents',
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollectionId}.documents',
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notCollectionId}.documents',
    ]).stream;
  }
}

final realtimeAPIProvider = Provider((ref) {
  final realtime = ref.watch(appwriteRealtimeProvider);
  return RealtimeAPI(realtime: realtime);
});
