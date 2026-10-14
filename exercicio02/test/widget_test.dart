import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercicio02/main.dart';

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
  testWidgets('rejeita nome curto depois de trim', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField), ' Al ');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(
      find.text('O nome deve ter pelo menos três caracteres.'),
      findsOneWidget,
    );
  });
  testWidgets('erro limpa saudação antiga e Limpar reinicia formulário', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextFormField), 'Ana');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('Olá, Ana!'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.textContaining('Olá,'), findsNothing);
    expect(find.text('Informe o nome.'), findsOneWidget);
    await tester.tap(find.text('Limpar'));
    await tester.pump();
    expect(find.text('Informe o nome.'), findsNothing);
    expect(find.textContaining('Olá,'), findsNothing);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      '',
    );
  });
}
