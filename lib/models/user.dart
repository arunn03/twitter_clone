import 'package:flutter/foundation.dart';

class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePicture;
  final String coverPicture;
  final String uid;
  final String bio;
  final bool isVerified;
  UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePicture,
    required this.coverPicture,
    required this.uid,
    required this.bio,
    required this.isVerified,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePicture,
    String? coverPicture,
    String? uid,
    String? bio,
    bool? isVerified,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePicture: profilePicture ?? this.profilePicture,
      coverPicture: coverPicture ?? this.coverPicture,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'followers': followers,
      'following': following,
      'profilePicture': profilePicture,
      'coverPicture': coverPicture,
      'bio': bio,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      profilePicture: map['profilePicture'] as String,
      coverPicture: map['coverPicture'] as String,
      uid: map['\$id'] as String,
      bio: map['bio'] as String,
      isVerified: map['isVerified'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePicture: $profilePicture, coverPicture: $coverPicture, uid: $uid, bio: $bio, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePicture == profilePicture &&
        other.coverPicture == coverPicture &&
        other.uid == uid &&
        other.bio == bio &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePicture.hashCode ^
        coverPicture.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        isVerified.hashCode;
  }
}
