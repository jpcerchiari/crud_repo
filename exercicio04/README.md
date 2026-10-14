# Exercício 4: Cancelamento sem efeitos colaterais

Cancelar fecha o formulário com Navigator.pop(context), sem devolver um produto. O resultado é null: no cadastro, a tela principal não acrescenta nada; na edição, a tela de detalhes mantém o produto original. Enquanto o usuário digita, as alterações ficam nos controllers. O novo Produto só é criado ao salvar.

Na exclusão, o item só sai da lista quando o diálogo devolve true. Os retornos false e null mantêm o produto e a contagem.

## Executar no navegador

```sh
cd exercicio04
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
| Cancelar cadastro preenchido | Contagem continua zero | Passou no Chrome |
| Mouse 50/Original; editar tudo e cancelar | Nome, preço e descrição originais preservados | Passou no Chrome |
| Cancelar exclusão e dispensar diálogo | Produto e contagem preservados | Passou no Chrome |

Os testes automatizados estão em `test/widget_test.dart`. Esta versão mantém o que foi feito nos exercícios anteriores.
