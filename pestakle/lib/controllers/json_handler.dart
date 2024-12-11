import 'dart:convert';

class JSONHandler {
  static final JSONHandler _jsonHandler = JSONHandler._internal();
  factory JSONHandler() {
    return _jsonHandler;
  }
  JSONHandler._internal();

  Future<String> login(
      String email, String password, String name, String photo) async {
    Map<String, String> parameters = {
      "mail": email,
      "password": password,
      "name": name,
      "photo": photo,
    };
    return jsonEncode(parameters);
  }

  Future<String> accestoken(
    String token,
  ) async {
    Map<String, String> parameters = {
      "token": token,
    };
    return jsonEncode(parameters);
  }

  Future<String> userModify(String name, String photo) async {
    Map<String, String> parameters = {
      'username': name,
      'image': photo,
    };
    return jsonEncode(parameters);
  }

  Future<String> createPost({
    required String title,
    required String description,
    String? image,
    double? latitude,
    double? longitude,
  }) async {
    Map<String, String> parameters = {
      'title': title,
      'description': description,
      'image': image.toString(),
      'lat': latitude.toString(),
      'lon': longitude.toString(),
    };

    if (image != null) {
      parameters['image'] = image;
    }

    if (latitude != null && longitude != null) {
      parameters['lat'] = latitude.toString();
      parameters['lon'] = longitude.toString();
    }

    return jsonEncode(parameters);
  }

  Future<String> sendMessage({
    required String postId,
    required String content,
  }) async {
    Map<String, String> parameters = {
      'postId': postId,
      'content': content,
    };
    return jsonEncode(parameters);
  }
}
