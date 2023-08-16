import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/core.dart';

final storageAPIProvider = Provider(
  (ref) {
    final storage = ref.watch(appwriteStorageProvider);
    return StorageAPI(storage: storage);
  },
);

abstract class IStorageAPI {
  Future<List<String>> uploadImages(List<File> files);
}

class StorageAPI implements IStorageAPI {
  const StorageAPI({required Storage storage}) : _storage = storage;

  final Storage _storage;

  @override
  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final image = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppwriteConstants.imageURL(image.$id));
    }
    return imageLinks;
  }
}
