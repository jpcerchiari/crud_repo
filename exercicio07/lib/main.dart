import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TelaProdutos(),
  );
}

class Produto {
  final String nome;
  final double preco;
  final String descricao;
  final int quantidade;
  const Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.quantidade,
  });
}

double? converterPreco(String texto) =>
    double.tryParse(texto.trim().replaceAll(',', '.'));

String? validarPreco(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'Informe o preço.';
  final preco = converterPreco(valor);
  if (preco == null || !preco.isFinite) return 'Digite um número válido.';
  if (preco <= 0) return 'O preço deve ser maior que zero.';
  return null;
}

String? validarQuantidade(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'Informe a quantidade.';
  final quantidade = int.tryParse(valor.trim());
  if (quantidade == null) return 'Digite uma quantidade inteira.';
  if (quantidade < 0) return 'A quantidade deve ser maior ou igual a zero.';
  return null;
}

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});
  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  // shortcut: dados só em memória, adicionar persistência quando o capítulo exigir.
  final List<Produto> produtos = [];

  double get totalEstoque {
    double total = 0;
    for (final produto in produtos) {
      total += produto.preco * produto.quantidade;
    }
    return total;
  }

  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> cadastrar() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (_) => TelaFormulario(
          nomesExistentes: produtos.map((p) => p.nome).toList(),
        ),
      ),
    );
    if (!mounted || novo == null) return;
    setState(() {
      produtos.add(novo);
    });
    avisar('Produto cadastrado com sucesso.');
  }

  Future<void> abrirDetalhes(Produto produto) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (_) => TelaDetalhes(
          produto: produto,
          nomesExistentes: produtos
              .where((p) => p != produto)
              .map((p) => p.nome)
              .toList(),
        ),
      ),
    );
    if (!mounted || atualizado == null) return;
    final indice = produtos.indexOf(produto);
    if (indice == -1) {
      avisar('Produto não encontrado.');
      return;
    }
    setState(() => produtos[indice] = atualizado);
    avisar('Produto atualizado.');
  }

  Future<void> excluir(Produto produto) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir ${produto.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (!mounted || confirmou != true) return;
    final indice = produtos.indexOf(produto);
    if (indice == -1) {
      avisar('Produto não encontrado.');
      return;
    }
    setState(() => produtos.removeAt(indice));
    avisar('Produto excluído.');
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = produtos;
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos em memória')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Produtos cadastrados: ${produtos.length}'),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Total do estoque: R\$ ${totalEstoque.toStringAsFixed(2)}',
            ),
          ),
          Expanded(
            child: visiveis.isEmpty
                ? Center(child: Text('Nenhum produto cadastrado.'))
                : ListView.builder(
                    itemCount: visiveis.length,
                    itemBuilder: (context, indice) {
                      final produto = visiveis[indice];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(produto.nome),
                          subtitle: Text(
                            'R\$ ${produto.preco.toStringAsFixed(2)}'
                            ' • Quantidade: ${produto.quantidade}'
                            ' • Estoque: R\$ ${(produto.preco * produto.quantidade).toStringAsFixed(2)}',
                          ),
                          onTap: () => abrirDetalhes(produto),
                          trailing: IconButton(
                            tooltip: 'Excluir ${produto.nome}',
                            icon: const Icon(Icons.delete),
                            onPressed: () => excluir(produto),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Cadastrar produto',
        onPressed: cadastrar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  final Produto produto;
  final List<String> nomesExistentes;
  const TelaDetalhes({
    super.key,
    required this.produto,
    this.nomesExistentes = const [],
  });

  Future<void> editar(BuildContext context) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TelaFormulario(produto: produto, nomesExistentes: nomesExistentes),
      ),
    );
    if (!context.mounted || atualizado == null) return;
    Navigator.pop(context, atualizado);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalhes do produto')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(produto.nome, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Preço: R\$ ${produto.preco.toStringAsFixed(2)}'),
          Text('Quantidade: ${produto.quantidade}'),
          Text(
            'Valor em estoque: R\$ ${(produto.preco * produto.quantidade).toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),
          Text(
            produto.descricao.isEmpty ? 'Sem descrição.' : produto.descricao,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => editar(context),
            child: const Text('Editar'),
          ),
        ],
      ),
    ),
  );
}

class TelaFormulario extends StatefulWidget {
  final Produto? produto;

  final List<String> nomesExistentes;
  const TelaFormulario({
    super.key,
    this.produto,
    this.nomesExistentes = const [],
  });
  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final chave = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController precoController;
  late final TextEditingController descricaoController;
  late final TextEditingController quantidadeController;
  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    precoController = TextEditingController(
      text: widget.produto?.preco.toString() ?? '',
    );
    descricaoController = TextEditingController(
      text: widget.produto?.descricao ?? '',
    );
    quantidadeController = TextEditingController(
      text: widget.produto?.quantidade.toString() ?? '',
    );
  }

  void salvar() {
    if (!chave.currentState!.validate()) return;
    Navigator.pop(
      context,
      Produto(
        nome: nomeController.text.trim(),
        preco: converterPreco(precoController.text)!,
        descricao: descricaoController.text.trim(),
        quantidade: int.parse(quantidadeController.text.trim()),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.produto == null ? 'Cadastrar produto' : 'Editar produto',
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: chave,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (valor) {
                final nome = valor?.trim() ?? '';
                if (nome.isEmpty) return 'Informe o nome.';
                if (nome.length < 3) {
                  return 'O nome deve ter pelo menos três caracteres.';
                }
                if (widget.nomesExistentes.any(
                  (outro) => outro.trim().toLowerCase() == nome.toLowerCase(),
                )) {
                  return 'Já existe um produto com esse nome.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: precoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Preço',
                helperText: 'Ex.: 12,50 (sem R\$ ou separador de milhar)',
              ),
              validator: validarPreco,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
              ),
              validator: (valor) => (valor?.length ?? 0) > 120
                  ? 'A descrição deve ter no máximo 120 caracteres.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              validator: validarQuantidade,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: salvar, child: const Text('Salvar')),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    ),
  );
}
