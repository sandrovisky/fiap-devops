import 'package:app/injection_container.dart' as di;
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    setUp(() async {
      // Reset GetIt antes de cada teste
      await di.getIt.reset();
      await di.init();
    });

    testWidgets('buscar CEP válido e exibir resultado', (
      WidgetTester tester,
    ) async {
      // Inicializa o app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verifica se está na tela inicial
      expect(find.text('Busca de CEP'), findsOneWidget);
      expect(find.text('Digite um CEP para buscar'), findsOneWidget);

      // Encontra o campo de texto e insere o CEP
      final cepField = find.byType(TextFormField);
      expect(cepField, findsOneWidget);

      await tester.enterText(cepField, '01310100');
      await tester.pumpAndSettle();

      // Clica no botão de buscar (busca pelo texto diretamente)
      final searchButton = find.text('Buscar');
      expect(searchButton, findsOneWidget);

      await tester.tap(searchButton);
      await tester.pump();

      // Espera o loading aparecer
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Espera a resposta da API (timeout de 10 segundos)
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verifica se o resultado foi exibido
      expect(find.text('Endereço Encontrado'), findsOneWidget);
      expect(find.text('Avenida Paulista'), findsOneWidget);
      expect(find.text('São Paulo'), findsOneWidget);
      expect(find.text('SP'), findsOneWidget);
    });

    testWidgets('buscar CEP inválido e exibir erro', (
      WidgetTester tester,
    ) async {
      // Inicializa o app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Encontra o campo de texto e insere um CEP inválido
      final cepField = find.byType(TextFormField);
      await tester.enterText(cepField, '123');
      await tester.pumpAndSettle();

      // Clica no botão de buscar
      final searchButton = find.text('Buscar');
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Verifica se a mensagem de erro foi exibida
      expect(find.text('CEP deve conter 8 dígitos'), findsOneWidget);
    });

    testWidgets('buscar CEP não encontrado e exibir erro', (
      WidgetTester tester,
    ) async {
      // Inicializa o app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Encontra o campo de texto e insere um CEP que não existe
      final cepField = find.byType(TextFormField);
      await tester.enterText(cepField, '99999999');
      await tester.pumpAndSettle();

      // Clica no botão de buscar
      final searchButton = find.text('Buscar');
      await tester.tap(searchButton);
      await tester.pump();

      // Espera a resposta da API
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verifica se a mensagem de erro foi exibida
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('não encontrado'), findsOneWidget);
    });
  });
}
