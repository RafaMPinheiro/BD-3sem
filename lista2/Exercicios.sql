DROP DATABASE IF EXISTS cinema;

CREATE DATABASE cinema;

\c cinema;

CREATE SCHEMA externo;

CREATE SCHEMA interno;

SET search_path TO public, externo, interno;

CREATE TABLE
    externo.telespectador (
        id serial PRIMARY KEY,
        cpf character(11) UNIQUE,
        nome text NOT NULL
    );

CREATE TABLE
    externo.filme (
        id serial PRIMARY KEY,
        titulo text NOT NULL,
        duracao integer CHECK (duracao > 0)
    );

CREATE TABLE
    public.sala (
        id serial PRIMARY KEY,
        nome text NOT NULL,
        capacidade integer CHECK (capacidade > 0)
    );

CREATE TABLE
    externo.sessao (
        id serial PRIMARY KEY,
        filme_id integer REFERENCES externo.filme(id),
        sala_id integer REFERENCES public.sala(id),
        data date NOT NULL,
        hora time NOT NULL
    );

CREATE TABLE
    externo.ingresso (
        id serial PRIMARY KEY,
        telespectador_id integer REFERENCES externo.telespectador(id),
        sessao_id integer REFERENCES externo.sessao(id),
        valor_ingresso real,
        corredor character(1) NOT NULL,
        poltrona integer CHECK (poltrona > 0),
        valor_pago real
    );

CREATE TABLE
    interno.setor (
        id serial PRIMARY KEY,
        descricao text,
        valor_por_hora real
    );

CREATE TABLE
    interno.funcionario (
        id serial PRIMARY KEY,
        nome text NOT NULL,
        setor_id integer REFERENCES interno.setor(id)
    );

CREATE TABLE
    interno.turno (
        sala_id integer REFERENCES public.sala(id),
        funcionario_id integer REFERENCES interno.funcionario(id),
        data_hora_entrada timestamp DEFAULT CURRENT_TIMESTAMP,
        data_hora_saida timestamp
    );

INSERT INTO
    externo.telespectador (cpf, nome)
VALUES (
        '11111111111',
        'Maria Oliveira'
    ), ('22222222222', 'Pedro Santos'), ('33333333333', 'Ana Silva'), ('44444444444', 'Lucas Souza'), (
        '55555555555',
        'Isabela Almeida'
    );

INSERT INTO
    externo.filme (titulo, duracao)
VALUES ('Ação Explosiva', 120), ('Comédia Louca', 90), ('Drama Intenso', 150), ('Aventuras Mágicas', 110), ('Suspense Misterioso', 140);

INSERT INTO
    public.sala (nome, capacidade)
VALUES 
('Sala A', 80),
('Sala B', 100),
('Sala C', 60),
('Sala D', 120),
('Sala E', 90);

INSERT INTO
    externo.sessao (filme_id, sala_id, data, hora)
VALUES
(1, 1, CURRENT_DATE, '18:00:00'),
(2, 2, CURRENT_DATE, '20:30:00'),
(3, 3, CURRENT_DATE, '15:00:00'),
(4, 4, CURRENT_DATE, '18:30:00'),
(5, 5, CURRENT_DATE, '16:45:00'),
(2, 4, CURRENT_DATE, '18:30:00'),
(2, 2, CURRENT_DATE, '18:30:00'),
(4, 3, CURRENT_DATE, '18:30:00');

INSERT INTO
    externo.ingresso (
        telespectador_id,
        sessao_id,
        valor_ingresso,
        corredor,
        poltrona,
        valor_pago
    )
VALUES 
(1, 1, 12.5, 'B', 10, 12.5),
(2, 2, 15.0, 'C', 5, 15.0), 
(3, 3, 10.0, 'A', 8, 10.0), 
(4, 4, 13.0, 'D', 15, 13.0), 
(5, 5, 11.5, 'E', 20, 11.5),
(2, 6, 11.5, 'E', 20, 11.5),
(1, 7, 11.5, 'E', 20, 11.5);

INSERT INTO
    interno.setor (descricao, valor_por_hora)
VALUES 
('Departamento de Vendas',25.5),
('Departamento de Recursos Humanos',30.0),
('Departamento de Tecnologia',35.75),
('Departamento Financeiro',28.75),
('Departamento de Marketing',27.0);

INSERT INTO
    interno.funcionario (nome, setor_id)
VALUES ('João Silva', 1), ('Maria Santos', 2), ('Pedro Almeida', 3), ('Ana Oliveira', 4), ('Rafael Costa', 5);

INSERT INTO
    interno.turno (
        sala_id,
        funcionario_id,
        data_hora_entrada,
        data_hora_saida
    )
VALUES 
(1, 1, '2023-08-28 08:00:00', '2023-08-28 12:00:00'),
(2, 2, '2023-08-28 13:30:00', '2023-08-28 17:30:00'),
(3, 3, '2023-08-28 08:00:00', '2023-08-28 12:00:00'),
(4, 4, '2023-08-29 19:00:00', '2023-08-29 23:00:00'),
(5, 3, '2023-08-29 08:00:00', '2023-08-29 12:00:00');
(1,1,'2023-08-28 08:00:00','2023-08-28 16:00:00'),
(2,2,'2023-08-28 14:00:00','2023-08-28 22:00:00'),
(3,3,'2023-08-28 09:00:00','2023-08-28 16:45:00'),
(4,4,'2023-08-29 09:30:00','2023-08-29 18:30:00'),
(5,3,'2023-08-29 10:00:00','2023-08-29 17:00:00');
INSERT INTO
    externo.ingresso (
        telespectador_id,
        sessao_id,
        valor_ingresso,
        corredor,
        poltrona,
        valor_pago
    )
VALUES (3, 3, 12.5, 'B', 10, 12.5), (1, 2, 12.5, 'B', 10, 12.5);

-- 2)
SELECT
    telespectador.cpf,
    telespectador.nome,
    STRING_AGG ( CAST(sessao.id AS text), ', ' ORDER BY sessao.id) "Sessão",
    count(ingresso.id) as qntd
FROM externo.ingresso
    INNER JOIN externo.telespectador ON (telespectador.id = ingresso.telespectador_id)
    INNER JOIN externo.sessao ON (ingresso.sessao_id = sessao.id)
WHERE (EXTRACT(MONTH FROM sessao.data) = EXTRACT(MONTH FROM current_date)) 
AND (EXTRACT(YEAR FROM sessao.data) = EXTRACT(YEAR FROM current_date))
GROUP BY
    telespectador.cpf,
    telespectador.nome
ORDER BY
    telespectador.nome;

-- 3)
SELECT sala.id, CAST(AVG(ingresso.id) AS numeric (8,2)) FROM ingresso
INNER JOIN sessao ON (sessao.id = ingresso.sessao_id)
INNER JOIN sala ON (sala.id = sessao.sala_id)
WHERE sessao.data >= current_date - INTERVAL '7 day'
GROUP BY sala.id
HAVING avg(ingresso.id) >= 5
ORDER BY sala.id;

-- 4)
CREATE OR REPLACE VIEW ex4 AS SELECT telespectador.nome, telespectador.cpf
FROM telespectador 
INNER JOIN ingresso ON (telespectador.id = ingresso.telespectador_id)
INNER JOIN sessao ON (ingresso.sessao_id = sessao.id)
WHERE sessao.data = current_date
ORDER BY RANDOM()
LIMIT 1;
SELECT * FROM ex4;

-- 5)
SELECT filme.id, filme.titulo, COUNT(ingresso.id) FROM sessao 
LEFT JOIN filme ON (sessao.filme_id = filme.id)
INNER JOIN ingresso on (ingresso.sessao_id = sessao.id)
WHERE EXTRACT(YEAR FROM sessao.data) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY filme.id
HAVING COUNT(ingresso.id) = (SELECT COUNT(ingresso.id) FROM sessao 
LEFT JOIN filme ON (sessao.filme_id = filme.id)
INNER JOIN ingresso on (ingresso.sessao_id = sessao.id)
WHERE EXTRACT(YEAR FROM sessao.data) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY filme.id
ORDER BY COUNT(ingresso.id) DESC LIMIT 1);

-- 6)
CREATE OR REPLACE VIEW ex6 AS SELECT sala.nome, filme.titulo, telespectador.nome, 
TO_CHAR(sessao.data, 'DD/MM/YYYY'), TO_CHAR(sessao.hora, 'HH24:MI'),
ingresso.corredor, ingresso.poltrona FROM telespectador
INNER JOIN ingresso ON (telespectador.id = ingresso.telespectador_id)
INNER JOIN sessao ON (ingresso.sessao_id = sessao.id)
INNER JOIN filme ON (sessao.filme_id = filme.id)
INNER JOIN sala ON (sessao.sala_id = sala.id)
ORDER BY sala.nome;

-- 7)
SELECT 
    CASE 
        WHEN CAST(data_hora_entrada AS time) >= '08:00:00' AND CAST(data_hora_entrada AS time) <= '12:00:00' THEN 'Manhã'  
        WHEN CAST(data_hora_entrada AS time) >= '13:30:00' AND CAST(data_hora_entrada AS time) <= '17:30:00' THEN 'Tarde'  
        WHEN CAST(data_hora_entrada AS time) >= '19:00:00' AND CAST(data_hora_entrada AS time) <= '23:00:00' THEN 'Noite'  
    END AS "Turno", COUNT(*) AS "Qtnd"
FROM turno
WHERE EXTRACT(YEAR FROM data_hora_entrada) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY "Turno";