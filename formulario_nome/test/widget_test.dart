import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formulario_nome/main.dart';

void main() {
  testWidgets('rejeita vazio e espaços', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final nome in ['', '  ']) {
      await tester.enterText(find.byType(TextFormField), nome);
      await tester.tap(find.text('Confirmar'));
      await tester.pump();
      expect(find.text('Informe o nome.'), findsOneWidget);
      expect(find.textContaining('Olá,'), findsNothing);
    }
  });
  testWidgets('confirma e remove espaços das extremidades', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField), '  Ana  ');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('Olá, Ana!'), findsOneWidget);
  });
  testWidgets('nome de um caractere é válido no exemplo base', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField), 'A');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('Olá, A!'), findsOneWidget);
  });
}
