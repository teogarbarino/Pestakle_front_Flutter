import 'package:shared_preferences/shared_preferences.dart';

class PersistanceHandler {
  Future<void> setAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Init
    prefs.setString('accessToken', accessToken);
  }

  Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Init
    return prefs.getString('accessToken') ?? "notFound";
  }

  Future<void> delAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Init
    prefs.remove('accessToken');
  }
}
