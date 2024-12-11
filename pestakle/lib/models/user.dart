import 'dart:convert';

class User {
  final String name;
  final String email;
  final String password;
  String? photo;
  final List<String>? posts;
  final List<String>? feed;
  final String id;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.photo,
    this.posts,
    this.feed,
    required this.id,
  });

  // Factory constructor to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      photo: json['photo'] as String?,
      posts: List<String>.from(json['posts'] ?? []),
      feed: List<String>.from(json['feed'] ?? []),
    );
  }

  // Method to convert a User instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'photo': photo,
      'posts': posts,
      'feed': feed,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
