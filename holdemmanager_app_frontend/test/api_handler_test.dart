import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:holdemmanager_app/Helpers/api_handler.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ApiHandler', () {
    late MockClient client;

    setUp(() {
      client = MockClient();
      ApiHandler.client = client;
    });

    testWidgets('checkTokenAndFetchData devuelve false cuando el token ha expirado', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'tokenExpiry': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      });

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Container();
          },
        ),
      ));

      BuildContext context = tester.element(find.byType(Container));

      final result = await ApiHandler.checkTokenAndFetchData(context);

      expect(result, false);
    });

    testWidgets('checkTokenAndFetchData devuelve true cuando el token es válido', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'tokenExpiry': DateTime.now().add(Duration(days: 1)).toIso8601String(),
      });

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Container();
          },
        ),
      ));

      BuildContext context = tester.element(find.byType(Container));

      final result = await ApiHandler.checkTokenAndFetchData(context);

      expect(result, true);
    });
  });
}