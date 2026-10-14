# Exercício 9: Identidade estável dos registros

Cada cadastro recebe o valor de proximoId. O contador só avança quando o cadastro é aceito e não diminui após uma exclusão. Ao editar, o produto mantém o id original.

Para editar ou excluir, indexWhere procura o registro pelo id. Se o retorno for -1, a operação é interrompida e o aplicativo avisa que não encontrou o produto.

## Executar no navegador

```sh
cd exercicio09
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
| Cadastrar IDs 1,2,3; excluir 2; cadastrar novo | Novo ID 4 | Passou no Chrome |
| Filtrar Monitor e editar | ID 3 preservado; contagem 3 | Passou no Chrome |
| Registro removido enquanto aguarda edição | Feedback Produto não encontrado.; sem exceção | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
