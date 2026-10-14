# Exercício 3: Regras adicionais para o produto

O nome do produto precisa ter pelo menos três caracteres. A descrição é opcional e aceita até 120. Cadastro e edição usam TelaFormulario, então as mesmas regras valem nas duas telas.

## Executar no navegador

```sh
cd exercicio03
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
| Nome Al no cadastro e na edição | Nome rejeitado | Passou no Chrome |
| Descrição vazia e com 120 caracteres | Cadastro aceito | Passou no Chrome |
| Descrição com 121 caracteres | Erro; formulário permanece aberto | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
