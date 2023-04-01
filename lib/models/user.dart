import 'adress.dart';

class UserProfile {
  String id;
  Adress? adress;

  UserProfile({
    required this.id,
    this.adress,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      adress: json['adress'] != null
          ? Adress.fromJson(json['adress'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adress': adress?.toJson(),
    };
  }

  UserProfile copyWith({
    String? id,
    Adress? adress,
  }) {
    return UserProfile(
      id: id ?? this.id,
      adress: adress ?? this.adress,
    );
  }
}
