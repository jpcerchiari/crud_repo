# Exercício 1: Nome válido e mensagem personalizada

O nome precisa ter pelo menos três caracteres depois de remover os espaços das pontas com trim(). A verificação usa isEmpty e length. A saudação só aparece quando validate() retorna true.

## Executar no navegador

```sh
cd exercicio01
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
| Campo vazio ou dois espaços | Informe o nome.; sem saudação | Passou no Chrome |
| Al, inclusive com espaços externos | Erro de pelo menos três caracteres | Passou no Chrome |
|   Ana   | Olá, Ana! | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
