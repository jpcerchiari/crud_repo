# Exercício 8: Buscar e editar o produto correto

A busca mantém as referências aos produtos da lista original. Ao tocar em um resultado, a tela recebe o próprio Produto e usa indexOf para encontrar sua posição antes de editar ou excluir. Isso evita usar a posição da busca como se fosse a posição original: o segundo produto pode aparecer na posição zero depois do filtro.

## Executar no navegador

```sh
cd exercicio08
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
| Mouse, Teclado, Monitor; buscar tEcLaDo | 3 cadastrados e 1 encontrado | Passou no Chrome |
| Editar Teclado filtrado de 20 para 25 | Somente segundo registro muda; total 70→80 | Passou no Chrome |
| Excluir Teclado filtrado e limpar busca | Mouse e Monitor preservados; sem resultado sob filtro | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
