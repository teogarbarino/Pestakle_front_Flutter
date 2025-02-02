class User {
  final String username;
  final String email;
  final String address;
  final String bio;
  final String profilePicture; // Encodé en base64
  final String role;
  final double trustIndex;
  final UserSettings userSettings;

  User({
    required this.username,
    required this.email,
    required this.address,
    required this.bio,
    required this.profilePicture,
    required this.role,
    required this.trustIndex,
    required this.userSettings,
  });

  // Conversion JSON -> Objet
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      bio: json['bio'] as String,
      profilePicture: json['profilePicture'] as String,
      role: json['role'] as String,
      trustIndex: (json['trustIndex'] as num).toDouble(),
      userSettings: UserSettings.fromJson(json['userSettings']),
    );
  }

  // Conversion Objet -> JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'address': address,
      'bio': bio,
      'profilePicture': profilePicture,
      'role': role,
      'trustIndex': trustIndex,
      'userSettings': userSettings.toJson(),
    };
  }
}

class UserSettings {
  final String theme; // 'light' ou 'dark'
  final double fontSize;

  UserSettings({
    required this.theme,
    required this.fontSize,
  });

  // Conversion JSON -> Objet
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: json['theme'] as String,
      fontSize: (json['fontSize'] as num).toDouble(),
    );
  }

  // Conversion Objet -> JSON
  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'fontSize': fontSize,
    };
  }
}
