import 'package:holdemmanager_app/Models/Noticia.dart';

class ResultListNoticia {
  List<Noticia>? noticia;
  bool valid;
  String message;

  ResultListNoticia({
    this.noticia,
    required this.valid,
    required this.message,
  });
}
