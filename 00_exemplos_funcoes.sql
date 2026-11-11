-- ============================================================
-- 00 - EXEMPLOS: FUNCOES (ADAPTADOS PARA SQLITE / DB BROWSER)
-- Aula 17 - CREATE FUNCTION
--
-- IMPORTANTE:
-- SQLite/DB Browser nao permite criar FUNCTION armazenada com
-- CREATE FUNCTION como no MySQL. Os exemplos abaixo reproduzem
-- a logica usando recursos nativos do SQLite: expressoes,
-- CASE, subconsultas, CTEs e funcoes internas.
-- ============================================================

-- ------------------------------------------------------------
-- Preparacao: tabelas de exemplo usadas nesta aula
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Fornecedor;

CREATE TABLE Fornecedor (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    id_fornecedor INTEGER,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id)
);

CREATE TABLE Estoque (
    id INTEGER PRIMARY KEY,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 0,
    preco REAL NOT NULL DEFAULT 0,
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

INSERT INTO Fornecedor (id, nome) VALUES
(1, 'Moinho Central'),
(2, 'Distribuidora Pao Bom'),
(3, 'Alimentos Gerais');

INSERT INTO Produto (id, nome, id_fornecedor) VALUES
(1, 'Farinha de trigo', 1),
(2, 'Acucar', 2),
(3, 'Chocolate', 3);

INSERT INTO Estoque (id, id_produto, quantidade, preco) VALUES
(1, 1, 20, 8.50),
(2, 2, 5, 6.00),
(3, 3, 0, 15.50);

-- ------------------------------------------------------------
-- 1. Funcao com parametros: calcular_valor_estoque
-- MySQL: calcular_valor_estoque(quantidade, preco)
-- SQLite: multiplicacao diretamente na consulta.
-- ------------------------------------------------------------
SELECT
    id_produto,
    quantidade,
    preco,
    quantidade * preco AS valor_total
FROM Estoque;

-- Chamada simples equivalente a calcular_valor_estoque(12, 15.50)
SELECT 12 * 15.50 AS resultado;

-- ------------------------------------------------------------
-- 2. Funcao que consulta uma tabela: nome_produto(codigo)
-- SQLite: subconsulta escalar retorna o nome ou NULL.
-- ------------------------------------------------------------
SELECT (
    SELECT nome
    FROM Produto
    WHERE id = 1
) AS nome;

-- ------------------------------------------------------------
-- 3. Variaveis e condicionais: classificar_preco(preco)
-- ------------------------------------------------------------
SELECT
    preco,
    CASE
        WHEN preco < 10 THEN 'Acessivel'
        WHEN preco < 50 THEN 'Intermediario'
        ELSE 'Premium'
    END AS faixa
FROM Estoque;

-- ------------------------------------------------------------
-- 4. CASE: descricao_quantidade(quantidade)
-- ------------------------------------------------------------
SELECT
    id_produto,
    quantidade,
    CASE
        WHEN quantidade = 0 THEN 'Esgotado'
        WHEN quantidade <= 10 THEN 'Pouco estoque'
        ELSE 'Estoque adequado'
    END AS situacao
FROM Estoque;

-- ------------------------------------------------------------
-- 5. Repeticao WHILE: somar_numeros(limite)
-- CTE recursiva soma de 1 ate o limite.
-- ------------------------------------------------------------
WITH RECURSIVE soma(contador, total) AS (
    SELECT 1, 1
    UNION ALL
    SELECT contador + 1, total + contador + 1
    FROM soma
    WHERE contador < 5
)
SELECT total AS resultado
FROM soma
WHERE contador = 5;

-- ------------------------------------------------------------
-- 6. Repeticao LOOP: equivalente para limite 5.
-- A CTE termina quando contador atinge o limite.
-- ------------------------------------------------------------
WITH RECURSIVE repeticao(contador, total) AS (
    SELECT 1, 1
    UNION ALL
    SELECT contador + 1, total + contador + 1
    FROM repeticao
    WHERE contador < 5
)
SELECT total AS resultado
FROM repeticao
WHERE contador = 5;

-- ------------------------------------------------------------
-- 7. Substituir funcao existente
-- No SQLite nao ha FUNCTION armazenada para remover/recriar.
-- Altere a expressao SQL usada na consulta quando necessario.
-- ------------------------------------------------------------
SELECT quantidade * preco AS valor_total_atualizado
FROM Estoque;

-- ------------------------------------------------------------
-- 8. Consultar funcoes
-- Funcoes nativas e funcoes definidas pela aplicacao nao ficam
-- cadastradas como rotinas em sqlite_master.
-- sqlite_master lista objetos do banco (tabelas, views etc.).
-- ------------------------------------------------------------
SELECT name, type
FROM sqlite_master
WHERE type IN ('table', 'view', 'index', 'trigger')
ORDER BY type, name;

-- ------------------------------------------------------------
-- 9. Funcoes internas uteis do SQLite
-- ------------------------------------------------------------
SELECT
    UPPER('banco de dados') AS texto_maiusculo,
    LOWER('BANCO DE DADOS') AS texto_minusculo,
    LENGTH('SQLite') AS quantidade_caracteres,
    TRIM('   produto   ') AS texto_sem_espacos,
    ROUND(12.345, 2) AS valor_arredondado;

-- ------------------------------------------------------------
-- 10. Diferenca entre procedure e function (conceito)
-- Em SQLite, nao ha procedures/functions armazenadas como no
-- MySQL. SELECT pode calcular e retornar um valor na consulta.
-- ------------------------------------------------------------
SELECT 'Uma consulta pode retornar um valor calculado.' AS observacao;
