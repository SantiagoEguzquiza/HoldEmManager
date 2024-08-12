import 'dart:convert';

import 'package:holdemmanager_app/Helpers/api_handler.dart';
import 'package:holdemmanager_app/Helpers/result.dart';
import 'package:holdemmanager_app/Models/Feedback/FeedbackEnum.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackModel {
  int? id;
  int? idUsuario;
  DateTime fecha;
  String mensaje;
  FeedbackEnum categoria;
  bool isAnonimo;

  FeedbackModel({
    this.id,
    this.idUsuario,
    required this.fecha,
    required this.mensaje,
    required this.categoria,
    this.isAnonimo = false,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      idUsuario: json['idUsuario'],
      fecha: DateTime.parse(json['fecha']),
      mensaje: json['mensaje'],
      categoria: FeedbackEnum.values[json['categoria']],
      isAnonimo: json['isAnonimo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'fecha': fecha.toIso8601String(),
      'mensaje': mensaje,
      'categoria': categoria.index,
      'isAnonimo': isAnonimo,
    };
  }

  static Future<Result> enviarFeedback(String mensaje, int idUsuario,
      DateTime fecha, bool isAnonimo, FeedbackEnum categoria, context) async {
    try {
      var baseUrl = ApiHandler.baseUrl;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('jwt_token') ?? '';
      bool valid = await ApiHandler.checkTokenAndFetchData(context);

      if (valid) {
        final response = await http.post(
          Uri.parse('$baseUrl/FeedbackApp'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, dynamic>{
            'idUsuario': idUsuario,
            'fecha': fecha.toIso8601String(),
            'mensaje': mensaje,
            'categoria': categoria.index,
            'isAnonimo': isAnonimo,
          }),
        );

        if (response.statusCode != 200) {
            return Result(valid: false, message: 'feebackError');         
        }
        return Result(valid: true, message: '');
      }else{
        return Result(valid: false, message: 'sesionEx');
      }
    } catch (e) {
      return Result(valid: false, message: 'serverError');
    }
  }
}
