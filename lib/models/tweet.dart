import 'package:flutter/foundation.dart';

import 'package:twitter_clone/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
  final String id;
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> images;
  final String uid;
  final TweetType tweetType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final int reshareCount;
  final String retweetedBy;
  const Tweet({
    required this.id,
    required this.text,
    required this.link,
    required this.hashtags,
    required this.images,
    required this.uid,
    required this.tweetType,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.reshareCount,
    required this.retweetedBy,
  });

  Tweet copyWith({
    String? id,
    String? text,
    String? link,
    List<String>? hashtags,
    List<String>? images,
    String? uid,
    TweetType? tweetType,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    int? reshareCount,
    String? retweetedBy,
  }) {
    return Tweet(
      id: id ?? this.id,
      text: text ?? this.text,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      images: images ?? this.images,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'link': link,
      'hashtags': hashtags,
      'images': images,
      'uid': uid,
      'tweetType': tweetType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reshareCount': reshareCount,
      'retweetedBy': retweetedBy,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      id: map['\$id'] ?? '',
      text: map['text'] ?? '',
      link: map['link'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      images: List<String>.from(map['images']),
      uid: map['uid'] ?? '',
      tweetType: TweetType.toEnum(map['tweetType']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      reshareCount: map['reshareCount'] ?? 0,
      retweetedBy: map['retweetedBy'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Tweet(id: $id, text: $text, link: $link, hashtags: $hashtags, images: $images, uid: $uid, tweetType: $tweetType, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, reshareCount: $reshareCount, retweetedBy: $retweetedBy)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.link == link &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.images, images) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.reshareCount == reshareCount &&
        other.retweetedBy == retweetedBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        link.hashCode ^
        hashtags.hashCode ^
        images.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        reshareCount.hashCode ^
        retweetedBy.hashCode;
  }
}
