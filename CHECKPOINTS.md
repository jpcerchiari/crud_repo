# Checkpoints e fluxo do código

## Checkpoint 1

a) Um nome com três espaços não identifica a pessoa; trim() torna essa entrada vazia. b) Um validator retorna null quando o campo é válido. c) O controller lê, limpa e preenche o texto; GlobalKey<FormState> dá acesso ao estado para validate() e reset().

## Checkpoint 2

| Entrada | Retorno |
| --- | --- |
| Vazio | Informe o preço. |
| abc | Digite um número válido. |
| 0 e -5 | O preço deve ser maior que zero. |
| 12,50 | null (aceito como 12.50) |
| NaN e Infinity | Digite um número válido. |

Teclado numérico só facilita a entrada. Colagem, teclado físico e entradas especiais ainda exigem validação. O mesmo converterPreco é usado para validar e salvar.

## Checkpoint 3

Salvar cria um novo Produto, devolve-o com Navigator.pop e faz a tela de detalhes retornar o resultado para a tela principal, que substitui o registro. Cancelar devolve null e conserva o objeto original. add() na edição criaria um segundo produto; substituir mantém a contagem. Controllers contêm o texto da tentativa, sem modificar os atributos final do original.

## Checkpoint 4

false é o cancelamento explícito no botão; null vem de fechar o diálogo sem resultado, como clicar fora dele ou voltar. Só true confirma a exclusão. A lista pertence ao State de TelaProdutos e muda nessa tela. O SnackBar aparece depois do retorno porque é nesse momento que o resultado foi aceito e a lista realmente atualizada. mounted/context.mounted impede usar uma tela que já saiu da árvore após await.

## Como validar, devolver e atualizar

O botão Salvar chama validate(). Se houver erro, permanece na tela; se tudo estiver correto, converte os dados e devolve Produto. Cadastro aceita o resultado e chama add(). Edição substitui a posição encontrada por referência (8) ou id (9 e 10). Exclusão remove a posição apenas após confirmação. setState reconstrói lista, contagens e total.

## Perguntas dos exercícios

1. trim() impede que espaços das extremidades contem como parte útil do nome.
3. Uma tela compartilhada aplica as mesmas regras no cadastro e na edição.
6. Um total atualizado só no cadastro ficaria desatualizado depois de editar preço/quantidade ou excluir.
10. Persistência requer salvar e recuperar registros, preservar a sequência de IDs e tratar falhas do armazenamento. Não foi implementada nesta atividade.
