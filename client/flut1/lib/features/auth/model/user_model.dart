// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String profilePic;
  final String banner;
  final bool isAuthenticated;
  final int hope;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePic,
    required this.banner,
    required this.isAuthenticated,
    required this.hope,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    String? profilePic,
    String? banner,
    bool? isAuthenticated,
    int? hope,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hope: hope ?? this.hope,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
      'profilePic': profilePic,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'hope': hope,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      hope: map['hope'] as int,
      awards: List<String>.from(map['awards'] as List),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, profilePic: $profilePic, banner: $banner, isAuthenticated: $isAuthenticated, hope: $hope, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.name == name &&
        other.email == email &&
        other.uid == uid &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.isAuthenticated == isAuthenticated &&
        other.hope == hope &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        isAuthenticated.hashCode ^
        hope.hashCode ^
        awards.hashCode;
  }
}
