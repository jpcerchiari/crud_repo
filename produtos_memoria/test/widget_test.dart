import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:produtos_memoria/main.dart';

Future<void> tocar(WidgetTester tester, Finder alvo) async {
  await tester.ensureVisible(alvo);
  await tester.tap(alvo);
  await tester.pumpAndSettle();
}

Future<void> preencher(
  WidgetTester tester,
  String nome,
  String preco, {
  String descricao = '',
  String quantidade = '0',
}) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), nome);
  await tester.enterText(campos.at(1), preco);
  await tester.enterText(campos.at(2), descricao);
}

Future<void> cadastrar(
  WidgetTester tester,
  String nome,
  String preco, {
  String descricao = '',
  String quantidade = '0',
}) async {
  await tocar(tester, find.byTooltip('Cadastrar produto'));
  await preencher(
    tester,
    nome,
    preco,
    descricao: descricao,
    quantidade: quantidade,
  );
  await tocar(tester, find.text('Salvar'));
}

Future<void> editar(WidgetTester tester, String nome) async {
  await tocar(tester, find.text(nome));
  await tocar(tester, find.text('Editar'));
}

Future<void> excluir(
  WidgetTester tester,
  String nome, {
  bool confirmar = true,
}) async {
  await tocar(tester, find.byTooltip('Excluir $nome'));
  await tocar(tester, find.text(confirmar ? 'Excluir' : 'Cancelar'));
}

void main() {
  testWidgets('T1-T5 e T14: rejeita dados inválidos', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Produtos cadastrados: 0'), findsOneWidget);
    expect(find.text('Nenhum produto cadastrado.'), findsOneWidget);
    await tocar(tester, find.byTooltip('Cadastrar produto'));
    await preencher(tester, '', '');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Informe o nome.'), findsOneWidget);
    expect(find.text('Informe o preço.'), findsOneWidget);
    await preencher(tester, '   ', '10');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Informe o nome.'), findsOneWidget);
    for (final preco in ['abc', 'NaN', 'Infinity']) {
      await preencher(tester, 'Mouse', preco);
      await tocar(tester, find.text('Salvar'));
      expect(find.text('Digite um número válido.'), findsOneWidget);
    }
    for (final preco in ['0', '-2']) {
      await preencher(tester, 'Mouse', preco);
      await tocar(tester, find.text('Salvar'));
      expect(find.text('O preço deve ser maior que zero.'), findsOneWidget);
    }

    await tocar(tester, find.text('Cancelar'));
    expect(find.text('Produtos cadastrados: 0'), findsOneWidget);
  });

  testWidgets('T6-T8 e T12: cadastra, consulta, edita e exclui', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '12,50');
    expect(find.text('Produtos cadastrados: 1'), findsOneWidget);
    await tocar(tester, find.text('Mouse'));
    expect(find.text('Preço: R\$ 12.50'), findsOneWidget);
    expect(find.text('Sem descrição.'), findsOneWidget);
    await tocar(tester, find.text('Editar'));
    await preencher(tester, 'Mouse USB', '15', quantidade: '3');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Produtos cadastrados: 1'), findsOneWidget);
    expect(find.text('Mouse USB'), findsOneWidget);
    expect(find.text('Mouse'), findsNothing);
    await excluir(tester, 'Mouse USB');
    expect(find.text('Produtos cadastrados: 0'), findsOneWidget);
    expect(find.text('Nenhum produto cadastrado.'), findsOneWidget);
    expect(find.text('Produto excluído.'), findsOneWidget);
  });

  testWidgets('T9-T11: cancelamentos preservam todos os dados', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tocar(tester, find.byTooltip('Cadastrar produto'));
    await preencher(tester, 'Descartado', '100');
    await tocar(tester, find.text('Cancelar'));
    expect(find.text('Produtos cadastrados: 0'), findsOneWidget);
    await cadastrar(
      tester,
      'Mouse',
      '50',
      descricao: 'Original',
      quantidade: '3',
    );
    await editar(tester, 'Mouse');
    await preencher(
      tester,
      'Teclado',
      '100',
      descricao: 'Alterada',
      quantidade: '5',
    );
    await tocar(tester, find.text('Cancelar'));
    expect(find.text('Mouse'), findsOneWidget);
    expect(find.text('Preço: R\$ 50.00'), findsOneWidget);
    expect(find.text('Original'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await excluir(tester, 'Mouse', confirmar: false);
    expect(find.text('Produtos cadastrados: 1'), findsOneWidget);
    expect(find.text('Mouse'), findsOneWidget);
    await tocar(tester, find.byTooltip('Excluir Mouse'));
    await tester.tapAt(const Offset(5, 100));
    await tester.pumpAndSettle();
    expect(find.text('Produtos cadastrados: 1'), findsOneWidget);
  });
  testWidgets('T13: editar segundo mantém primeiro e terceiro', (tester) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10');
    await cadastrar(tester, 'Teclado', '20');
    await cadastrar(tester, 'Monitor', '30');
    await editar(tester, 'Teclado');
    await preencher(tester, 'Teclado USB', '25');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Mouse'), findsOneWidget);
    expect(find.text('Monitor'), findsOneWidget);
    expect(find.text('Teclado USB'), findsOneWidget);
    expect(find.text('Produtos cadastrados: 3'), findsOneWidget);
  });
}
