// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:twitter_clone/core/enums/notiffication_type_enum.dart';

@immutable
class Notification {
  final String id;
  final String text;
  final String postId;
  final String uid;
  final NotificationType notificationType;
  final DateTime createdAt;
  const Notification({
    required this.id,
    required this.text,
    required this.postId,
    required this.uid,
    required this.notificationType,
    required this.createdAt,
  });

  Notification copyWith({
    String? id,
    String? text,
    String? postId,
    String? uid,
    NotificationType? notificationType,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'postId': postId,
      'uid': uid,
      'notificationType': notificationType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      notificationType: NotificationType.toEnum(map['notificationType']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Notification(id: $id, text: $text, postId: $postId, uid: $uid, notificationType: $notificationType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Notification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.postId == postId &&
        other.uid == uid &&
        other.notificationType == notificationType &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        postId.hashCode ^
        uid.hashCode ^
        notificationType.hashCode ^
        createdAt.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
