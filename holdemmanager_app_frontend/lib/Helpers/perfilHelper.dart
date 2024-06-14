import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/ErrorMessage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilHelper {
  static late String finalName;
  static late String finalEmail;
  static late bool isLoading;
  static late String imagePath;
  static late Uint8List image;

  static Future<void> getDatosValidacion() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final obtenerName = sharedPreferences.getString('name');
    final obtenerEmail = sharedPreferences.getString('email');
    finalName = obtenerName ?? '';
    finalEmail = obtenerEmail ?? '';
    isLoading = false;
  }

  static Future<void> cargarImagen(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedImagePath = prefs.getString('userImagePath');

    if (savedImagePath != null) {
      final File imageFile = File(savedImagePath);
      if (await imageFile.exists()) {
        final Uint8List imageBytes = await imageFile.readAsBytes();
        imagePath = savedImagePath;
        image = imageBytes;
      }
    }
  }

  static Future<void> seleccionarImagen(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final File imageFile = File(file.path);
      const int maxSize = 1024 * 1024;

      if (await imageFile.length() > maxSize) {
        ErrorMessage.mostrarMensajeError(
            "El tamaño de la imagen excede el límite de 1 MB.", context);
        return;
      }

      final Uint8List imageBytes = await imageFile.readAsBytes();
      image = imageBytes;
      guardarImagen(file);
    }
  }

  static Future<void> guardarImagen(XFile file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(file.path);
      final String localPath = path.join(directory.path, fileName);

      final File imageFile = File(file.path);
      await imageFile.copy(localPath);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userImagePath', localPath);

      imagePath = localPath;
    } catch (e) {
      print("Error guardando la imagen: $e");
    }
  }
}