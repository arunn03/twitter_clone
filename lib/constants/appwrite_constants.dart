class AppwriteConstants {
  static const String databaseId = '64d84f77d73ca2f608d0';
  static const String projectId = '64d84d7e3c77857bb19b';
  static const String endPoint = 'http://192.168.29.52:80/v1';

  static const String usersCollectionId = '64d9cb78a68ea87f299f';
  static const String tweetsCollectionId = '64dae65f32e8d4473463';

  static const String imagesBucketId = '64db2f035ebfc8bfedd1';

  static String imageURL(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin';
}
