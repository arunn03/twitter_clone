enum NotificationType {
  like('like'),
  reply('reply'),
  retweet('retweet'),
  follow('follow');

  final String type;
  const NotificationType(this.type);

  static NotificationType toEnum(String type) {
    switch (type) {
      case 'like':
        return NotificationType.like;
      case 'reply':
        return NotificationType.reply;
      case 'retweet':
        return NotificationType.retweet;
      default:
        return NotificationType.follow;
    }
  }
}
