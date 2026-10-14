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

  const Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
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

class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});
  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  // shortcut: dados só em memória, adicionar persistência quando o capítulo exigir.
  final List<Produto> produtos = [];

  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> cadastrar() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(builder: (_) => TelaFormulario()),
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
      MaterialPageRoute(builder: (_) => TelaDetalhes(produto: produto)),
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
                            'R\$ ${produto.preco.toStringAsFixed(2)}',
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

  const TelaDetalhes({super.key, required this.produto});

  Future<void> editar(BuildContext context) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(builder: (_) => TelaFormulario(produto: produto)),
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

  const TelaFormulario({super.key, this.produto});
  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final chave = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController precoController;
  late final TextEditingController descricaoController;

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
  }

  void salvar() {
    if (!chave.currentState!.validate()) return;
    Navigator.pop(
      context,
      Produto(
        nome: nomeController.text.trim(),
        preco: converterPreco(precoController.text)!,
        descricao: descricaoController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    descricaoController.dispose();

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
