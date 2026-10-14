# Exercício 6: Valor total do estoque

O total é calculado percorrendo a lista e somando preço × quantidade de cada produto. O getter é chamado em build(), por isso o valor acompanha os cadastros, as edições e as exclusões. Se a soma fosse feita só ao cadastrar, ela ficaria desatualizada nas outras operações.

## Executar no navegador

```sh
cd exercicio06
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
| Lista vazia | Total R$ 0.00 | Passou no Chrome |
| A 10×3 e B 20×2 | Total R$ 70.00 | Passou no Chrome |
| Editar A para 20×3 e excluir A | Total R$ 100.00 e depois R$ 40.00 | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
