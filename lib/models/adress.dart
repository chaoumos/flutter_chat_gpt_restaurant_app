import 'dart:convert';

class Adress {
  final String adressLine1;
  final String city;

  final String postalCode;
  final String country;

  Adress({
    required this.adressLine1,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory Adress.fromJson(Map<String, dynamic> json) {
    return Adress(
      adressLine1: json['adressLine1'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adressLine1': adressLine1,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
