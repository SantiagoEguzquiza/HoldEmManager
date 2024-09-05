import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:holdemmanager_app/Models/Feedback/Feedback.dart';
import 'package:holdemmanager_app/Models/Usuario.dart';
import 'package:holdemmanager_app/Screens/login_screen.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilHelper {
  static late String finalName;
  static late String finalEmail;
  static late int numeroJugador;
  static late bool isLoading;
  static String? imagePath;
  static Uint8List? image;
  static late bool isLoggedIn;
  static List<FeedbackModel>? feedbacks;
  static String? status;

  static Future<void> getDatosValidacion() async {
    final prefs = await SharedPreferences.getInstance();
    
    finalName = prefs.getString('name') ?? '';
    finalEmail = prefs.getString('email') ?? '';
    numeroJugador = prefs.getInt('numberPlayer') ?? 0;
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    isLoading = false;
    status = null;

    if (isLoggedIn) {
      try {
        feedbacks = await Usuario.getFeedbacksPorUserId(prefs.getInt('userId') ?? -1);
      } catch (e) {
        status = e.toString().contains('sesionEx') ? 'sesionEx' : 'error';
      }
    }
  }

  static Future<void> cargarImagen() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('${finalEmail}_userImagePath');
    
    if (savedImagePath != null && await File(savedImagePath).exists()) {
      imagePath = savedImagePath;
      image = await File(savedImagePath).readAsBytes();
    } else {
      imagePath = null;
      image = null;
    }
  }

  static Future<String> seleccionarImagen() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final File imageFile = File(file.path);

      if (await imageFile.length() > 1024 * 1024) {
        return 'imageSize';
      }

      image = await imageFile.readAsBytes();
      return await guardarImagen(file) ? 'imageSaved' : '';
    }
    return '';
  }

  static Future<bool> guardarImagen(XFile file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String localPath = path.join(directory.path, path.basename(file.path));

      await File(file.path).copy(localPath);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('${finalEmail}_userImagePath', localPath);

      imagePath = localPath;
      return await Usuario.setImageUrl(localPath, numeroJugador);
    } catch (e) {
      return false;
    }
  }

  static Future<String> eliminarImagen() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('${finalEmail}_userImagePath');
    
    image = null;
    imagePath = null;
    
    return await Usuario.setImageUrl(null, numeroJugador) ? 'imageDeleted' : 'imageDeletedError';
  }

  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.clear();
    Get.offAll(() => const LoginScreen());
  }
}