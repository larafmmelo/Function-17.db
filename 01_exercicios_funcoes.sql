-- ============================================================
-- 01 - EXERCICIOS RESOLVIDOS: FUNCOES (SQLITE / DB BROWSER)
-- Aula 17 - Padaria, Farmacia, Agencia de Viagens e Supermercado
--
-- Os enunciados pedem FUNCTION armazenada em MySQL. Como o
-- SQLite nao oferece CREATE FUNCTION armazenada, cada resposta
-- abaixo implementa a mesma logica com SQL executavel no DB Browser.
-- ============================================================

PRAGMA foreign_keys = ON;

-- ------------------------------------------------------------
-- TABELAS E DADOS DE APOIO
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Supermercado_Produto;
DROP TABLE IF EXISTS Supermercado_Categoria;
DROP TABLE IF EXISTS Agencia_Pacote;
DROP TABLE IF EXISTS Agencia_Reserva;
DROP TABLE IF EXISTS Farmacia_Classe;
DROP TABLE IF EXISTS Farmacia_Medicamento;
DROP TABLE IF EXISTS Padaria_Lote;
DROP TABLE IF EXISTS Padaria_Estoque;
DROP TABLE IF EXISTS Padaria_Fornecedor;

CREATE TABLE Padaria_Fornecedor (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE Padaria_Estoque (
    id INTEGER PRIMARY KEY,
    ingrediente TEXT NOT NULL,
    saldo INTEGER NOT NULL
);

CREATE TABLE Padaria_Lote (
    id INTEGER PRIMARY KEY,
    data_fabricacao TEXT NOT NULL,
    data_validade TEXT NOT NULL
);

CREATE TABLE Farmacia_Classe (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE Farmacia_Medicamento (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    quantidade INTEGER NOT NULL,
    id_classe INTEGER,
    validade TEXT NOT NULL,
    FOREIGN KEY (id_classe) REFERENCES Farmacia_Classe(id)
);

CREATE TABLE Agencia_Pacote (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    vagas_disponiveis INTEGER NOT NULL,
    data_viagem TEXT NOT NULL,
    preco_diaria REAL NOT NULL
);

CREATE TABLE Agencia_Reserva (
    id INTEGER PRIMARY KEY,
    cliente TEXT NOT NULL,
    valor_passagem REAL NOT NULL,
    taxa_aeroportuaria REAL NOT NULL
);

CREATE TABLE Supermercado_Categoria (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    percentual_imposto REAL NOT NULL
);

CREATE TABLE Supermercado_Produto (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario REAL NOT NULL,
    estoque_minimo INTEGER NOT NULL,
    id_categoria INTEGER,
    FOREIGN KEY (id_categoria) REFERENCES Supermercado_Categoria(id)
);

INSERT INTO Padaria_Fornecedor VALUES
(1, 'Moinho Central'),
(2, 'Laticinios Minas'),
(3, 'Distribuidora Doce');

INSERT INTO Padaria_Estoque VALUES
(1, 'Farinha', 4),
(2, 'Acucar', 18),
(3, 'Fermento', 2);

INSERT INTO Padaria_Lote VALUES
(1, '2026-11-01', '2026-11-08'),
(2, '2026-11-03', '2026-11-13');

INSERT INTO Farmacia_Classe VALUES
(1, 'Analgesico'),
(2, 'Antibiotico'),
(3, 'Antialergico');

INSERT INTO Farmacia_Medicamento VALUES
(1, 'Paracetamol', 0, 1, '2026-12-20'),
(2, 'Amoxicilina', 6, 2, '2026-10-30'),
(3, 'Loratadina', 35, 3, '2027-03-15');

INSERT INTO Agencia_Pacote VALUES
(1, 'Praia', 2, '2026-12-20', 180.00),
(2, 'Serra', 12, '2026-11-20', 320.00),
(3, 'Cidade Historica', 0, '2027-01-15', 90.00);

INSERT INTO Agencia_Reserva VALUES
(1, 'Ana', 850.00, 75.00),
(2, 'Bruno', 1200.00, 95.00);

INSERT INTO Supermercado_Categoria VALUES
(1, 'Alimentos', 7.0),
(2, 'Higiene', 12.0),
(3, 'Limpeza', 10.0);

INSERT INTO Supermercado_Produto VALUES
(1, 'Arroz', 4, 25.90, 5, 1),
(2, 'Sabonete', 30, 3.50, 8, 2),
(3, 'Detergente', 2, 2.99, 5, 3);

-- ============================================================
-- PADARIA
-- ============================================================

-- Exercicio 1: preco com acrescimo de 10%.
SELECT
    100.00 AS preco_original,
    ROUND(100.00 * 1.10, 2) AS preco_com_acrescimo;

-- Exercicio 2: quantidade vendida -> UNITARIO ou ATACADO.
-- Criterio de exemplo: limite de 10 unidades.
SELECT
    8 AS quantidade_vendida,
    CASE
        WHEN 8 >= 10 THEN 'ATACADO'
        ELSE 'UNITARIO'
    END AS tipo_venda;

-- Exercicio 3: consultar nome do fornecedor pelo codigo.
SELECT (
    SELECT nome
    FROM Padaria_Fornecedor
    WHERE id = 2
) AS nome_fornecedor;

-- Exercicio 4: informar se o saldo de farinha esta abaixo de 5.
SELECT
    ingrediente,
    saldo,
    CASE
        WHEN saldo < 5 THEN 'Abaixo de cinco unidades'
        ELSE 'Estoque suficiente'
    END AS situacao
FROM Padaria_Estoque
WHERE ingrediente = 'Farinha';

-- Exercicio 5: dias entre fabricacao e validade do lote.
SELECT
    id,
    data_fabricacao,
    data_validade,
    CAST(julianday(data_validade) - julianday(data_fabricacao) AS INTEGER) AS dias_entre_datas
FROM Padaria_Lote;

-- ============================================================
-- FARMACIA
-- ============================================================

-- Exercicio 6: total de item = quantidade * preco unitario.
SELECT
    3 AS quantidade_vendida,
    12.50 AS preco_unitario,
    ROUND(3 * 12.50, 2) AS total_item;

-- Exercicio 7: medicamento esgotado, baixo ou suficiente.
-- Criterio adotado: 0 = esgotado; ate 10 = baixo; acima de 10 = suficiente.
SELECT
    nome,
    quantidade,
    CASE
        WHEN quantidade = 0 THEN 'Esgotado'
        WHEN quantidade <= 10 THEN 'Baixo'
        ELSE 'Suficiente'
    END AS situacao
FROM Farmacia_Medicamento;

-- Exercicio 8: comparar validade com a data atual.
SELECT
    nome,
    validade,
    CASE
        WHEN date(validade) < date('now') THEN 'Vencido'
        ELSE 'Dentro da validade'
    END AS situacao_validade
FROM Farmacia_Medicamento;

-- Exercicio 9: retornar classe terapeutica pelo codigo.
SELECT
    m.nome AS medicamento,
    (SELECT c.nome FROM Farmacia_Classe c WHERE c.id = m.id_classe) AS classe_terapeutica
FROM Farmacia_Medicamento m;

-- Exercicio 10: calcular desconto com limite maximo definido.
-- Exemplo: desconto de 10%, limitado a R$ 20,00.
SELECT
    250.00 AS valor_compra,
    MIN(250.00 * 0.10, 20.00) AS desconto_aplicado,
    ROUND(250.00 - MIN(250.00 * 0.10, 20.00), 2) AS valor_final;

-- ============================================================
-- AGENCIA DE VIAGENS
-- ============================================================

-- Exercicio 11: passagem + taxa aeroportuaria.
SELECT
    cliente,
    valor_passagem,
    taxa_aeroportuaria,
    ROUND(valor_passagem + taxa_aeroportuaria, 2) AS valor_final
FROM Agencia_Reserva;

-- Exercicio 12: categoria do pacote pela quantidade de vagas.
-- Criterio de exemplo: ate 3 = Ultimas vagas; acima de 3 = Disponivel.
SELECT
    nome,
    vagas_disponiveis,
    CASE
        WHEN vagas_disponiveis = 0 THEN 'Esgotado'
        WHEN vagas_disponiveis <= 3 THEN 'Ultimas vagas'
        ELSE 'Disponivel'
    END AS categoria
FROM Agencia_Pacote;

-- Exercicio 13: unir nome e sobrenome e converter para maiusculas.
SELECT UPPER('Lara' || ' ' || 'Mello') AS nome_completo;

-- Exercicio 14: dias que faltam para a data da viagem.
SELECT
    nome,
    data_viagem,
    CAST(julianday(data_viagem) - julianday(date('now')) AS INTEGER) AS dias_que_faltam
FROM Agencia_Pacote;

-- Exercicio 15: classificar diaria como economica ou premium.
-- Criterio de exemplo: ate R$ 200 = Economica; acima = Premium.
SELECT
    nome,
    preco_diaria,
    CASE
        WHEN preco_diaria <= 200 THEN 'Economica'
        ELSE 'Premium'
    END AS categoria_diaria
FROM Agencia_Pacote;

-- ============================================================
-- SUPERMERCADO
-- ============================================================

-- Exercicio 16: preco da venda por quantidade e preco unitario.
SELECT
    nome,
    quantidade,
    preco_unitario,
    ROUND(quantidade * preco_unitario, 2) AS total_venda
FROM Supermercado_Produto;

-- Exercicio 17: determinar se produto esta com estoque critico.
SELECT
    nome,
    quantidade,
    estoque_minimo,
    CASE
        WHEN quantidade <= estoque_minimo THEN 'Estoque critico'
        ELSE 'Estoque normal'
    END AS situacao_estoque
FROM Supermercado_Produto;

-- Exercicio 18: consultar percentual de imposto pelo codigo da categoria.
SELECT
    p.nome AS produto,
    (SELECT c.percentual_imposto
     FROM Supermercado_Categoria c
     WHERE c.id = p.id_categoria) AS percentual_imposto
FROM Supermercado_Produto p;

-- Exercicio 19: no SQLite nao existem funcoes armazenadas para listar.
-- Esta consulta lista objetos do banco, como tabelas, views e triggers.
SELECT name, type
FROM sqlite_master
WHERE type IN ('table', 'view', 'trigger')
ORDER BY type, name;

-- Exercicio 20: remover espacos extras e padronizar o nome.
-- TRIM remove espacos das pontas; replace reduz espacos duplos internos.
SELECT
    nome AS nome_original,
    UPPER(TRIM(REPLACE(REPLACE(nome, '  ', ' '), '  ', ' '))) AS nome_padronizado
FROM Supermercado_Produto;

-- FIM DOS EXERCICIOS
