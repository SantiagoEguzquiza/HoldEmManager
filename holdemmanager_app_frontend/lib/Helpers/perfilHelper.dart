import 'dart:io';
import 'dart:typed_data';
import 'package:holdemmanager_app/Models/Usuario.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/ErrorMessage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilHelper {
  static late String finalName;
  static late String finalEmail;
  static late int numeroJugador = 0;
  static late bool isLoading;
  static late String? imagePath;
  static late Uint8List? image;

  static Future<void> getDatosValidacion() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final obtenerName = sharedPreferences.getString('name');
    final obtenerEmail = sharedPreferences.getString('email');
    final obtenerNumeroJugador = sharedPreferences.getInt('numberPlayer');
    finalName = obtenerName ?? '';
    finalEmail = obtenerEmail ?? '';
    numeroJugador = obtenerNumeroJugador ?? 0;
    isLoading = false;
  }

  static Future<void> cargarImagen(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? savedImagePath =
        prefs.getString('${finalEmail}_userImagePath');
    print(savedImagePath);
    if (savedImagePath != null) {
      final File imageFile = File(savedImagePath);
      if (await imageFile.exists()) {
        final Uint8List imageBytes = await imageFile.readAsBytes();
        print(savedImagePath);
        imagePath = savedImagePath;
        image = imageBytes;
      }
    } else {
      imagePath = null;
      image = null;
    }
  }

  static Future<String> seleccionarImagen(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final File imageFile = File(file.path);
      const int maxSize = 1024 * 1024;

      if (await imageFile.length() > maxSize) {
        return 'imageSize';
      }

      final Uint8List imageBytes = await imageFile.readAsBytes();
      image = imageBytes;
      if (await guardarImagen(file)) {
        return 'imageSaved';
      }
    }
    return '';
  }

  static Future<bool> guardarImagen(XFile file) async {
    bool valorBool = false;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(file.path);
      final String localPath = path.join(directory.path, fileName);

      final File imageFile = File(file.path);
      await imageFile.copy(localPath);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('${finalEmail}_userImagePath', localPath);

      imagePath = localPath;

      valorBool = await Usuario.setImageUrl(localPath, numeroJugador);
      return valorBool;
    } catch (e) {
      print("Error guardando la imagen: $e");
      return valorBool;
    }
  }
}
