class UserProfile {
  final String id;
  final String user; // Référence à l'utilisateur (ID)
  final String name;
  final String ageRange;
  final String productCondition;
  final List<String>? categories;
  final List<String>? brands;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.user,
    required this.name,
    required this.ageRange,
    required this.productCondition,
    this.categories,
    this.brands,
    required this.createdAt,
  });

  /// Création d'un UserProfile à partir d'un JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '', // Adapter selon votre backend
      user: json['user'] as String,
      name: json['name'] as String,
      ageRange: json['ageRange'] as String,
      productCondition: json['productCondition'] as String,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      brands: json['brands'] != null ? List<String>.from(json['brands']) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Conversion du UserProfile en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'name': name,
      'ageRange': ageRange,
      'productCondition': productCondition,
      'categories': categories,
      'brands': brands,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
