# Exercício 5: Quantidade em estoque

Produto passa a ter uma quantidade obrigatória em estoque. int.tryParse verifica se a entrada é um inteiro; abc e valores decimais são rejeitados. O validador também impede números negativos, mas aceita zero. O campo foi incluído nos construtores e controllers, na lista, nos detalhes e nos testes.

## Executar no navegador

```sh
cd exercicio05
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
| Quantidade vazia, abc, -1, 2.5 | Entradas rejeitadas com erro específico | Passou no Chrome |
| Quantidade 0 | Cadastro aceito e zero exibido | Passou no Chrome |
| Editar quantidade 3 para 5 | Formulário inicia com 3; lista passa a 5 | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
