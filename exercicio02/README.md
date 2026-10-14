# Exercício 2: Limpar e evitar uma saudação antiga

Se o nome for inválido, a saudação anterior é apagada. O botão Limpar chama FormState.reset(), esvazia o controller e apaga a mensagem, deixando o formulário sem os erros de validação.

## Executar no navegador

```sh
cd exercicio02
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
| Confirmar Ana e depois confirmar vazio | Saudação desaparece e o campo mostra erro | Passou no Chrome |
| Limpar depois de um erro | Campo, saudação e erros apagados | Passou no Chrome |
| Ana com espaços externos | Olá, Ana! | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
