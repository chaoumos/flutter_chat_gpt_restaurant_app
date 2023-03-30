class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double price;
  final double discount;
  final double ratings;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.discount,
    required this.ratings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'price': price,
      'discount': discount,
      'ratings': ratings,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      price: json.containsKey('price') ? json['price'].toDouble() : 0.0,
      discount:
          json.containsKey('discount') ? json['discount'].toDouble() : 0.0,
      ratings: json.containsKey('ratings') ? json['ratings'].toDouble() : 0.0,
    );
  }
}
