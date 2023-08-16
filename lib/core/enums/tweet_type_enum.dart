enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);

  static TweetType toEnum(String type) {
    switch (type) {
      case 'image':
        return TweetType.image;
      default:
        return TweetType.text;
    }
  }
}
