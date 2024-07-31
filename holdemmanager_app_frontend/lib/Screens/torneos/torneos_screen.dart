import 'package:flutter/material.dart';
import 'package:holdemmanager_app/Helpers/languageHelper.dart';
import 'package:holdemmanager_app/Services/TranslationService.dart';
import 'package:holdemmanager_app/Services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl

class TorneosPage extends StatefulWidget {
  const TorneosPage({super.key});

  @override
  _TorneosPage createState() => _TorneosPage();
}

class _TorneosPage extends State<TorneosPage> implements LanguageHelper {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> torneos;
  Map<DateTime, List<dynamic>> torneosPorFecha = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<String, dynamic> finalTranslations = {};
  final TranslationService translationService = TranslationService();
  late Locale finalLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    cargarLocaleYTranslations();
    translationService.addListener(this);
    torneos = apiService.obtenerTorneos().then((data) {
      setState(() {
        for (var torneo in data) {
          DateTime fecha = DateTime.parse(torneo['fecha']);
          fecha = DateTime(
              fecha.year, fecha.month, fecha.day); // Solo la parte de la fecha
          if (!torneosPorFecha.containsKey(fecha)) {
            torneosPorFecha[fecha] = [];
          }
          torneosPorFecha[fecha]!.add(torneo);
        }
        print('Torneos por fecha: $torneosPorFecha');
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
      finalLocale = locale ?? const Locale('en', 'US');
    });
  }

  String formatearFecha(DateTime fecha) {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          finalTranslations[finalLocale.toString()]?['tournaments'] ??
              'Torneos',
        ),
        backgroundColor: Colors.orangeAccent,
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
            return TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                day = DateTime(day.year, day.month, day.day);
                return torneosPorFecha[day] ?? [];
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day);
                  _focusedDay = focusedDay;
                });
                if (torneosPorFecha[_selectedDay] != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Torneos del día ${formatearFecha(_selectedDay!)}"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: torneosPorFecha[_selectedDay]!
                            .map<Widget>((torneo) => ListTile(
                                  title: Text(torneo['nombre']),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(torneo['nombre']),
                                        content: Text(
                                          "Fecha: ${formatearFecha(DateTime.parse(torneo['fecha']))}\n"
                                          "Modo de Juego: ${torneo['modoJuego']}\n"
                                          "Premios: ${torneo['premios']}",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cerrar"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cerrar"),
                        ),
                      ],
                    ),
                  );
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            );
          }
        },
      ),
    );
  }
}
