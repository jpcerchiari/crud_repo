# Nome: João Pedro Cerchiari
## RA: 202410096
### Ciência da Computação: 6º Semestre

# Formulários validados e CRUD em memória: seção 9

Cada pasta tem um aplicativo Flutter e corresponde a uma etapa da lista. Os dez exercícios avançam do formulário de nome até o cadastro completo de produtos. Os dados são apagados ao reiniciar o aplicativo.

| Pasta | Conteúdo |
| --- | --- |
| formulario_nome | Exemplo base de nome obrigatório |
| produtos_memoria | Exemplo base de CRUD |
| exercicio01 | Nome válido e mensagem personalizada |
| exercicio02 | Limpar e evitar uma saudação antiga |
| exercicio03 | Regras adicionais para o produto |
| exercicio04 | Cancelamento sem efeitos colaterais |
| exercicio05 | Quantidade em estoque |
| exercicio06 | Valor total do estoque |
| exercicio07 | Impedir nomes repetidos |
| exercicio08 | Buscar e editar o produto correto |
| exercicio09 | Identidade estável dos registros |
| exercicio10 | Gerenciador de produtos integrado |

## Executar

```sh
cd exercicio10
flutter pub get
flutter run -d chrome
```

## Testar

Na pasta do projeto que deseja testar, rode:

```sh
flutter analyze
flutter test --platform chrome --reporter expanded
```

O README de cada exercício explica a alteração e registra pelo menos três testes. A tabela T1 a T14 e os demais resultados estão em [TESTES.md](TESTES.md). As respostas dos quatro checkpoints e a explicação do fluxo estão em [CHECKPOINTS.md](CHECKPOINTS.md).

## Registro de dúvida e falha corrigida

No teste de edição com filtro ativo, a busca por `R$ 30.00` encontrou duas linhas: o preço do Monitor e o valor do estoque do Mouse.

O esperado era encontrar só o preço do Monitor e confirmar que ele continuava em R$ 30.00 depois da edição de Teclado. A asserção encontrou dois widgets e falhou, mesmo com os registros corretos.

O teste passou a verificar o início da linha do preço para diferenciá-lo do valor do estoque. O trecho está em `exercicio10/test/widget_test.dart`, no teste "T13: filtro edita e exclui somente o segundo registro".

```dart
find.byWidgetPredicate(
  (widget) => widget is Text &&
      (widget.data?.startsWith('R\$ 30.00 •') ?? false),
)
```

Com essa correção, o cenário passou no Chrome. Os desafios foram concluídos e não ficaram dúvidas pendentes.

## Demonstração para a correção

Na versão final, cadastre Mouse, Teclado e Monitor, nessa ordem. Busque Teclado, altere seu preço e limpe a busca. A lista deve continuar com três produtos, e os dados de Mouse e Monitor devem permanecer iguais.

No exercício 8, indexOf encontra o produto selecionado na lista original. Nos exercícios 9 e 10, indexWhere procura pelo id, que permanece o mesmo durante a edição.

## Ajuda externa

Foi utilizado a ferramenta ChatGPT para criar os READMEs presentes nos exercícios, incluindo os 3 presentes na raiz desse repositório. Além disso o mesmo foi utilizado para realizar testes automatizados para validar se a execução foi realizada corretamente.
