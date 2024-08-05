import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/NavBar/app_bar.dart';
import 'package:holdemmanager_app/NavBar/bottom_nav_bar.dart';
import 'package:holdemmanager_app/NavBar/side_bar.dart';
import 'package:holdemmanager_app/Screens/noticias/noticias_screen.dart';
import 'package:holdemmanager_app/Screens/profile_screen.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TorneosPage extends StatefulWidget {
  const TorneosPage({super.key});

  @override
  _TorneosPage createState() => _TorneosPage();
}

class _TorneosPage extends State<TorneosPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> torneos = Future.value([]);
  Map<String, List<dynamic>> torneosPorDia = {};
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('es', 'ES');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    cargarLocaleYTranslations();
    translationService.addListener(this);
    torneos = apiService.obtenerTorneos().then((data) {
      setState(() {
        for (var torneo in data) {
          DateTime fecha = DateTime.parse(torneo['fecha']);
          String dia = DateFormat('d ' 'MMMM' ' yyyy', 'es_ES').format(fecha);
          if (!torneosPorDia.containsKey(dia)) {
            torneosPorDia[dia] = [];
          }
          torneosPorDia[dia]!.add(torneo);
        }
        print('Torneos por día: $torneosPorDia');
      });
      return data;
    });
  }

  @override
  void dispose() {
    translationService.removeListener(this);
    super.dispose();
  }

  @override
  void actualizarLenguaje(Locale locale) {
    cargarLocaleYTranslations();
  }

  Future<void> cargarLocaleYTranslations() async {
    final Locale? locale = await translationService.getLocale();
    final Map<String, dynamic> translations =
        await translationService.getTranslations();

    setState(() {
      finalTranslations = translations;
      finalLocale = locale ?? const Locale('es', 'ES');
    });
  }

  String formatearFecha(DateTime fecha) {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: const CustomAppBar(),
      drawerScrimColor: const Color.fromARGB(0, 163, 141, 141),
      drawer: const SideBar(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoticiasScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),
      body: FutureBuilder<List<dynamic>>(
        future: torneos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar los torneos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay torneos disponibles"));
          } else {
            return ListView.builder(
              itemCount: torneosPorDia.keys.length,
              itemBuilder: (context, index) {
                String dia = torneosPorDia.keys.elementAt(index);
                List<dynamic> torneosDelDia = torneosPorDia[dia]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          dia.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Inicio')),
                          DataColumn(label: Text('Cierre')),
                          DataColumn(label: Text('Evento')),
                          DataColumn(label: Text('Stack')),
                          DataColumn(label: Text('Niveles')),
                          DataColumn(label: Text('Entrada')),
                        ],
                        rows: torneosDelDia.map((torneo) {
                          return DataRow(cells: [
                            DataCell(Text(torneo['numeroRef'])),
                            DataCell(Text(torneo['inicio'])),
                            DataCell(Text(torneo['cierre'])),
                            DataCell(Text(torneo['nombre'])),
                            DataCell(Text(torneo['stack'])),
                            DataCell(Text(torneo['niveles'])),
                            DataCell(Text(torneo['entrada'])),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
