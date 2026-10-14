# Resultados de testes web

Executados em 13/10/2026 com Flutter 3.47.2, Dart 3.13.2 e Google Chrome instalado. Os testes usam `flutter test --platform chrome`: compilam os aplicativos para o navegador e exercitam os widgets, os campos e as rotas. A execução parou em cada projeto apenas após sucesso.

| Projeto | Cenários aprovados | Chrome | flutter analyze |
| --- | --- | --- | --- |
| formulario_nome | 3 | Passou | Sem problemas |
| produtos_memoria | 4 | Passou | Sem problemas |
| exercicio01 | 3 | Passou | Sem problemas |
| exercicio02 | 4 | Passou | Sem problemas |
| exercicio03 | 5 | Passou | Sem problemas |
| exercicio04 | 5 | Passou | Sem problemas |
| exercicio05 | 6 | Passou | Sem problemas |
| exercicio06 | 7 | Passou | Sem problemas |
| exercicio07 | 8 | Passou | Sem problemas |
| exercicio08 | 8 | Passou | Sem problemas |
| exercicio09 | 10 | Passou | Sem problemas |
| exercicio10 | 12 | Passou | Sem problemas |

**Total: 75 cenários aprovados em 12 projetos.** Cada cenário pode verificar várias entradas e operações.

## Tabela T1 a T14

Resultados observados no teste da versão final (`exercicio10/test/widget_test.dart`), também cobertos nas versões do CRUD em que se aplicam.

| Caso | Resultado observado | Estado |
| --- | --- | --- |
| T1 | Nenhum produto cadastrado; cadastrados 0, encontrados 0 e total R$ 0.00. | Passou |
| T2 | Nome e preço vazios mostram Informe o nome. e Informe o preço.; formulário permanece aberto. | Passou |
| T3 | Nome com espaços e preço 10 mostra erro do nome; nada é cadastrado. | Passou |
| T4 | Mouse/abc mostra Digite um número válido. | Passou |
| T5 | 0 e -2 mostram O preço deve ser maior que zero. | Passou |
| T6 | Mouse/12,50 vira preço R$ 12.50; contagem passa de 0 para 1. | Passou |
| T7 | Descrição vazia mostra Sem descrição. nos detalhes. | Passou |
| T8 | Mouse/12,50 vira Mouse USB/15; quantidade de registros antes 1 e depois 1. | Passou |
| T9 | Mouse/50/Original/3, editado para Teclado/100/Alterada/5 e cancelado, mantém todos os dados originais; contagem 1. | Passou |
| T10 | Cadastro de Descartado cancelado; contagem antes 0 e depois 0. | Passou |
| T11 | Cancelar exclusão e fechar diálogo sem escolher botão preservam Mouse e contagem 1. | Passou |
| T12 | Excluir último produto deixa lista vazia, contagem 0 e feedback Produto excluído. | Passou |
| T13 | Antes: Mouse/10, Teclado/20, Monitor/30, contagem 3. Filtrar e editar Teclado para 25 mantém Mouse/10, Monitor/30 e contagem 3. | Passou |
| T14 | NaN e Infinity mostram Digite um número válido.; sem cadastro. | Passou |

## Regras adicionais

- Nome Al rejeitado e Ana com trim aceita; erro limpa a saudação no exercício 2 e Limpar reinicia o formulário.
- Descrição com 120 caracteres aceita; 121 rejeitada, inclusive na edição. Nome curto rejeitado em ambas as operações.
- Quantidade vazia, abc, -1 e 2.5 rejeitadas; zero aceito; edição inicia com 3 e salva 5.
- Total recalculado: vazio 0; A 10×3 e B 20×2 = 70; A editado para 20×3 = 100; excluir A = 40.
- Mouse e mouse duplicados; salvar o próprio nome permitido; renomear outro registro para Mouse rejeitado sem apagar a digitação.
- Busca sem diferenciação de caixa; contagens separadas; editar/excluir o segundo registro filtrado mantém os demais. Sem resultados mostra Nenhum produto encontrado.
- IDs 1,2,3; excluir 2 e cadastrar gera 4; editar o id 3 preserva 3. Registro ausente interrompe edição e exclusão com feedback, sem acessar -1.
- Formulário completo funciona nas dimensões 390×844 e 1280×800, sem exceções de layout.
