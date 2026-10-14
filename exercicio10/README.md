# Exercício 10: Gerenciador de produtos integrado

Esta versão reúne as funções dos exercícios anteriores. O total usa a lista completa de produtos, enquanto a busca monta a lista visiveis. Assim, filtrar os resultados não muda o total do estoque.

Os dados continuam em memória, sem banco de dados. Para mantê-los depois de fechar o aplicativo, seria preciso salvar os produtos e o controle de IDs no armazenamento local, recuperá-los na inicialização e tratar possíveis falhas de leitura ou gravação.

## Executar no navegador

```sh
cd exercicio10
flutter pub get
flutter run -d chrome
```

Ao reiniciar o aplicativo, os dados são apagados, pois ficam apenas na memória.

## Testes

```sh
flutter analyze
flutter test --platform chrome --reporter expanded
```

| Caso | Resultado esperado | Resultado observado |
| --- | --- | --- |
| Estoque 70; filtrar segundo registro | Total permanece R$ 70.00 | Passou no Chrome |
| Editar segundo registro com filtro ativo | Total passa a 80; primeiro e terceiro preservados | Passou no Chrome |
| Cancelar operações e confirmar exclusão | Cancelamentos preservam; exclusão confirmada remove | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.

A falha corrigida e o roteiro para demonstrar a edição com filtro estão no [README geral](../README.md).
