import 'package:http/http.dart' as http;

import 'package:pestakle/controllers/persistance_handler.dart';

class HttpService {
  HttpService._privateConstructor();

  static final HttpService _instance = HttpService._privateConstructor();

  factory HttpService() {
    return _instance;
  }

  //  ==================================================
  //        Requête utilisée pour faire les GET
  //  ==================================================
  Future<http.Response> makeGetRequestWithToken(String requestURL) async {
    // Requête classique
    http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${await PersistanceHandler().getAccessToken()}',
      },
    );
    // Si la première requête renvoie un 401

    return response;
  }

  Future<http.Response> makeGetRequestWithoutToken(String requestURL) async {
    // Requête classique
    http.Response response = await http.get(
      Uri.parse(requestURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //  ==================================================
  //        Requête utilisée pour faire les POST
  //  ==================================================
  Future<http.Response> makePostRequestWithToken(
      String requestURL, String params) async {
    // Première requête
    http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${await PersistanceHandler().getAccessToken()}',
      },
      body: params,
    );

    // Si la première requête renvoie un 401

    return response;
  }

  Future<http.Response> makePostRequestWithoutToken(
      String requestURL, String params) async {
    // Première requête
    http.Response response = await http.post(
      Uri.parse(requestURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: params,
    );
    return response;
  }

  //  ==================================================
  //        Requête utilisée pour faire les DEL
  //  ==================================================
  Future<http.Response> makeDeleteRequestWithToken(String requestURL) async {
    // Première requête
    http.Response response = await http.delete(
      Uri.parse(requestURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${await PersistanceHandler().getAccessToken()}',
      },
    );
    // Si la première requête renvoie un 401

    return response;
  }

  //  ==================================================
  //        Requête utilisée pour faire les PUT
  //  ==================================================
  Future<http.Response> makePUTRequestWithToken(
      String requestUrl, String params) async {
    // Premier essai
    http.Response response = await http.put(
      Uri.parse(requestUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer ${await PersistanceHandler().getAccessToken()}',
      },
      body: params,
    );
    // Si la première requête renvoie un 401

    return response;
  }
}
