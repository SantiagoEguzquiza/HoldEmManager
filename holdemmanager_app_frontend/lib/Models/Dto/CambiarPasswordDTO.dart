import 'dart:async';
import 'dart:convert';
import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CambiarPassworDTO {
  String passwordAnterior;
  String nuevaPassword;

  CambiarPassworDTO(
      {required this.nuevaPassword, required this.passwordAnterior});

  factory CambiarPassworDTO.fromJson(Map<String, dynamic> json) {
    return CambiarPassworDTO(
      passwordAnterior: json['passwordAnterior'],
      nuevaPassword: json['nuevaPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passwordAnterior': passwordAnterior,
      'nuevaPassword': nuevaPassword,
    };
  }

  static Future<Result> cambiarPassword(
      CambiarPassworDTO passwordDto, context) async {
    final String apiUrl = '${ApiHandler.baseUrl}/JugadorApp/CambiarPassword';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('jwt_token') ?? '';
    bool valid = await ApiHandler.checkTokenAndFetchData(context);
    if (valid) {
      try {
        var response = await http
            .put(
              Uri.parse(apiUrl),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(passwordDto.toJson()),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          return Result(valid: true, message: 'passwordUpdated');
        } else {
          return Result(valid: false, message: 'passwordError');
        }
      } on TimeoutException catch (e) {
        print(e);
        return Result(valid: false, message: 'serverError');
      } catch (e) {
        return Result(valid: false, message: '');
      }
    }
    return Result(valid: false, message: 'sesionEx');
  }
}
