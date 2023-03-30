class UserProfile {
  String id;

  String? address;

  UserProfile({
    required this.id,
    this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      address: json['address'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
    };
  }

  UserProfile copyWith({
    String? id,
    String? address,
  }) {
    return UserProfile(
      id: id ?? this.id,
      address: address ?? this.address,
    );
  }
}
