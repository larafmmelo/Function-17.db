# Aula 17 — Funções com CREATE FUNCTION (DB Browser / SQLite)

Este pacote contém os exemplos da aula e os 20 exercícios resolvidos, adaptados para execução no **DB Browser for SQLite**.

## Arquivos

- `00_exemplos_funcoes.sql` — exemplos da aula, organizados separadamente.
- `01_exercicios_funcoes.sql` — exercícios resolvidos de Padaria, Farmácia, Agência de Viagens e Supermercado.

## Atenção: diferença entre MySQL e SQLite

O material do professor ensina **funções armazenadas do MySQL**, criadas com `CREATE FUNCTION`, `RETURNS`, `BEGIN` e `RETURN`.

O SQLite usado pelo DB Browser **não oferece suporte a funções armazenadas criadas com `CREATE FUNCTION`**. Por isso, os arquivos deste pacote reproduzem a lógica com recursos que o SQLite executa diretamente, como:

- `CASE` para condições;
- expressões matemáticas para cálculos;
- subconsultas para consultar tabelas;
- `julianday()` e `date()` para cálculos com datas;
- `UPPER()`, `TRIM()`, `REPLACE()` e outras funções nativas;
- CTE recursiva para demonstrar a lógica de repetição.

Essas adaptações são consultas SQL executáveis, não funções armazenadas MySQL. Se o professor exigir especificamente a criação de `FUNCTION` com `CREATE FUNCTION`, será necessário executar a versão original em um servidor MySQL, e não no DB Browser/SQLite.

## Como executar no DB Browser

1. Abra o DB Browser for SQLite.
2. Clique em **Novo Banco de Dados**.
3. Salve um banco novo, por exemplo `exemplos_funcoes.db`.
4. Abra a aba **Executar SQL**.
5. Abra o arquivo `00_exemplos_funcoes.sql`, copie o conteúdo e cole na área SQL (ou use a opção de abrir arquivo SQL, se disponível).
6. Clique em **Executar tudo** (ícone de play).
7. Confira os resultados na área de resultados.
8. Para os exercícios, crie outro banco novo, por exemplo `exercicios_funcoes.db`, e execute `01_exercicios_funcoes.sql`.

## Por que usar um banco separado para cada arquivo?

Os scripts começam removendo tabelas de exemplo com `DROP TABLE IF EXISTS` e depois criam tabelas e dados novamente. Usar bancos separados evita apagar ou misturar tabelas de outros trabalhos.

## Observações sobre critérios dos exercícios

Alguns enunciados não informam os limites ou percentuais necessários para classificar os resultados. Para que os exemplos sejam executáveis, foram adotados critérios ilustrativos e comentados no próprio SQL. Se o professor fornecer valores específicos, substitua os valores indicados nos comentários.

## Publicar no GitHub

1. Crie ou abra o repositório da disciplina.
2. Clique em **Add file** → **Upload files**.
3. Envie os dois arquivos `.sql` e este `README.md`.
4. Clique em **Commit changes**.

## Compatibilidade

Os scripts foram preparados para SQLite e validados quanto à execução SQL. Os resultados de datas usam a data atual do computador/SQLite no momento da execução.
