import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Usuario.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  static http.Client client = http.Client();

  static final baseUrl = Uri.parse('https://www.holdemmanager.somee.com');

  static Future<Result> login(Usuario usuario) async { 
    try {
      var urlApi = ('/LoginApp');
      var apiUrl = baseUrl.resolve(urlApi);

      var response = await client
          .post(
            apiUrl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(usuario.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      Result result = Result(valid: false, message: response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.valid = true;
        await guardarToken(result.message);
        return result;
      } else {
        return result;
      }
    } on TimeoutException catch (e) {
      print(e);
      return Result(valid: false, message: 'serverError');
    } catch (e) {
      return Result(valid: false, message: 'serverError');
    }
  }

  static Future<void> guardarToken(String message) async {
    try {
      Map<String, dynamic> messageJson = jsonDecode(message);

      String token = messageJson['token'];
      int userId = messageJson['id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setInt('userId', userId);
      await prefs.setString('tokenExpiry',
          DateTime.now().add(const Duration(days: 1)).toIso8601String());
    } catch (e) {}
  }

  static Future<bool> checkTokenAndFetchData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenExpiryStr = prefs.getString('tokenExpiry');

    if (tokenExpiryStr != null) {
      DateTime tokenExpiry = DateTime.parse(tokenExpiryStr);

      if (DateTime.now().isAfter(tokenExpiry)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}