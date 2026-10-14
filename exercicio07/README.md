# Exercício 7: Impedir nomes repetidos

Para verificar nomes repetidos, o formulário recebe os nomes dos outros produtos, sem precisar da lista mutável inteira. A comparação usa trim().toLowerCase(). Se houver um nome igual, o erro aparece no campo. Na edição, o próprio produto fica fora da comparação, permitindo salvar sem mudar o nome.

## Executar no navegador

```sh
cd exercicio07
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
| Mouse existente; cadastrar  mouse  | Duplicado rejeitado sem perder digitação | Passou no Chrome |
| Editar Mouse mantendo o nome | Salva; contagem continua 2 | Passou no Chrome |
| Renomear Teclado para Mouse | Duplicado rejeitado | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
