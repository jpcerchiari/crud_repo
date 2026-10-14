import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercicio10/main.dart';

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
  await tester.enterText(campos.at(3), quantidade);
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
    await preencher(tester, 'Al', '10');
    await tocar(tester, find.text('Salvar'));
    expect(
      find.text('O nome deve ter pelo menos três caracteres.'),
      findsOneWidget,
    );
    await preencher(tester, 'Mouse', '10', descricao: 'x' * 121);
    await tocar(tester, find.text('Salvar'));
    expect(
      find.text('A descrição deve ter no máximo 120 caracteres.'),
      findsOneWidget,
    );
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
    expect(find.text('Quantidade: 3'), findsOneWidget);
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
  testWidgets(
    'descrição com 120 caracteres aceita no cadastro e validada na edição',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await cadastrar(tester, 'Mouse', '10', descricao: 'x' * 120);
      expect(find.text('Produtos cadastrados: 1'), findsOneWidget);
      await editar(tester, 'Mouse');
      await preencher(tester, 'Al', '10', descricao: 'x' * 121);
      await tocar(tester, find.text('Salvar'));
      expect(
        find.text('O nome deve ter pelo menos três caracteres.'),
        findsOneWidget,
      );
      expect(
        find.text('A descrição deve ter no máximo 120 caracteres.'),
        findsOneWidget,
      );
    },
  );
  testWidgets('quantidade inteira: erros, zero e edição de 3 para 5', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tocar(tester, find.byTooltip('Cadastrar produto'));
    for (final quantidade in ['', 'abc', '-1', '2.5']) {
      await preencher(tester, 'Mouse', '10', quantidade: quantidade);
      await tocar(tester, find.text('Salvar'));
      expect(find.text('Cadastrar produto'), findsOneWidget);
      final erro = quantidade.isEmpty
          ? 'Informe a quantidade.'
          : quantidade == '-1'
          ? 'A quantidade deve ser maior ou igual a zero.'
          : 'Digite uma quantidade inteira.';
      expect(find.text(erro), findsOneWidget);
    }
    await preencher(tester, 'Mouse', '10', quantidade: '0');
    await tocar(tester, find.text('Salvar'));
    expect(find.textContaining('Quantidade: 0'), findsOneWidget);
    await editar(tester, 'Mouse');
    await preencher(tester, 'Mouse', '10', quantidade: '3');
    await tocar(tester, find.text('Salvar'));
    await editar(tester, 'Mouse');
    expect(find.text('3'), findsOneWidget);
    await preencher(tester, 'Mouse', '10', quantidade: '5');
    await tocar(tester, find.text('Salvar'));
    expect(find.textContaining('Quantidade: 5'), findsOneWidget);
  });
  testWidgets('total passa de zero para 70, 100 e 40', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Total do estoque: R\$ 0.00'), findsOneWidget);
    await cadastrar(tester, 'Produto A', '10', quantidade: '3');
    await cadastrar(tester, 'Produto B', '20', quantidade: '2');
    expect(find.text('Total do estoque: R\$ 70.00'), findsOneWidget);
    await editar(tester, 'Produto A');
    await preencher(tester, 'Produto A', '20', quantidade: '3');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Total do estoque: R\$ 100.00'), findsOneWidget);
    await excluir(tester, 'Produto A');
    expect(find.text('Total do estoque: R\$ 40.00'), findsOneWidget);
  });
  testWidgets('nomes únicos sem rejeitar o próprio nome na edição', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10');
    await cadastrar(tester, 'Teclado', '20');
    await tocar(tester, find.byTooltip('Cadastrar produto'));
    await preencher(tester, ' mouse ', '30');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Já existe um produto com esse nome.'), findsOneWidget);
    expect(find.text(' mouse '), findsOneWidget);
    await tocar(tester, find.text('Cancelar'));
    await editar(tester, 'Mouse');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Produtos cadastrados: 2'), findsOneWidget);
    await editar(tester, 'Teclado');
    await preencher(tester, 'Mouse', '20');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Já existe um produto com esse nome.'), findsOneWidget);
  });
  testWidgets('T13: filtro edita e exclui somente o segundo registro', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10', quantidade: '3');
    await cadastrar(tester, 'Teclado', '20', quantidade: '2');
    await cadastrar(tester, 'Monitor', '30', quantidade: '0');
    await tester.enterText(find.byType(TextField), 'tEcLaDo');
    await tester.pumpAndSettle();
    expect(find.text('Produtos encontrados: 1'), findsOneWidget);
    expect(find.text('Produtos cadastrados: 3'), findsOneWidget);
    expect(find.text('Total do estoque: R\$ 70.00'), findsOneWidget);
    await editar(tester, 'Teclado');
    await preencher(tester, 'Teclado', '25', quantidade: '2');
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Total do estoque: R\$ 80.00'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.textContaining('R\$ 10.00'), findsOneWidget);
    expect(find.textContaining('R\$ 25.00'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text && (widget.data?.startsWith('R\$ 30.00 •') ?? false),
      ),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'teclado');
    await tester.pumpAndSettle();
    await excluir(tester, 'Teclado');
    expect(find.text('Nenhum produto encontrado.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Mouse'), findsOneWidget);
    expect(find.text('Monitor'), findsOneWidget);
    expect(find.text('Produtos cadastrados: 2'), findsOneWidget);
  });
  testWidgets('ids 1, 2, 3, exclusão de 2 e próximo id 4', (tester) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10');
    await cadastrar(tester, 'Teclado', '20');
    await cadastrar(tester, 'Monitor', '30');
    await excluir(tester, 'Teclado');
    await cadastrar(tester, 'Cabo USB', '5');
    expect(find.textContaining('ID: 4'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'monitor');
    await tester.pumpAndSettle();
    await editar(tester, 'Monitor');
    await preencher(tester, 'Monitor LED', '35');
    await tocar(tester, find.text('Salvar'));
    expect(find.textContaining('ID: 3'), findsOneWidget);
    expect(find.text('Produtos cadastrados: 3'), findsOneWidget);
  });
  testWidgets('id ausente interrompe edição com feedback', (tester) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10');
    final dynamic estado = tester.state(find.byType(TelaProdutos));
    await editar(tester, 'Mouse');
    // Simula remoção do registro enquanto o formulário aguarda o retorno.
    estado.produtos.clear();
    await tocar(tester, find.text('Salvar'));
    expect(find.text('Produto não encontrado.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('formulário funciona em largura de celular e desktop', (
    tester,
  ) async {
    for (final tamanho in [const Size(390, 844), const Size(1280, 800)]) {
      await tester.binding.setSurfaceSize(tamanho);
      await tester.pumpWidget(const MyApp());
      await tocar(tester, find.byTooltip('Cadastrar produto'));
      await preencher(
        tester,
        'Produto responsivo',
        '12,50',
        descricao: 'Teste de largura',
        quantidade: '2',
      );
      await tocar(tester, find.text('Salvar'));
      expect(find.text('Produto responsivo'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  });
  testWidgets('id ausente interrompe exclusão com feedback', (tester) async {
    await tester.pumpWidget(const MyApp());
    await cadastrar(tester, 'Mouse', '10');
    final dynamic estado = tester.state(find.byType(TelaProdutos));
    await tocar(tester, find.byTooltip('Excluir Mouse'));
    estado.produtos.clear();
    await tocar(tester, find.text('Excluir'));
    expect(find.text('Produto não encontrado.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
