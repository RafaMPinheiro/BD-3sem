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
VALUES ('Sala A', 80), ('Sala B', 100), ('Sala C', 60), ('Sala D', 120), ('Sala E', 90);

INSERT INTO
    externo.sessao (filme_id, sala_id, data, hora)
VALUES (1, 1, '2023-08-28', '18:00:00'), (2, 2, '2023-08-28', '20:30:00'), (3, 3, '2023-08-29', '15:00:00'), (4, 4, '2023-08-29', '18:30:00'), (5, 5, '2023-08-30', '16:45:00');

INSERT INTO
    externo.ingresso (
        telespectador_id,
        sessao_id,
        valor_ingresso,
        corredor,
        poltrona,
        valor_pago
    )
VALUES (1, 1, 12.5, 'B', 10, 12.5), (2, 2, 15.0, 'C', 5, 15.0), (3, 3, 10.0, 'A', 8, 10.0), (4, 4, 13.0, 'D', 15, 13.0), (5, 5, 11.5, 'E', 20, 11.5);

INSERT INTO
    interno.setor (descricao, valor_por_hora)
VALUES (
        'Departamento de Vendas',
        25.5
    ), (
        'Departamento de Recursos Humanos',
        30.0
    ), (
        'Departamento de Tecnologia',
        35.75
    ), (
        'Departamento Financeiro',
        28.75
    ), (
        'Departamento de Marketing',
        27.0
    );

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
VALUES (
        1,
        1,
        '2023-08-28 09:00:00',
        '2023-08-28 18:00:00'
    ), (
        2,
        2,
        '2023-08-28 10:30:00',
        '2023-08-28 17:30:00'
    ), (
        3,
        3,
        '2023-08-28 08:45:00',
        '2023-08-28 16:45:00'
    ), (
        4,
        4,
        '2023-08-29 09:30:00',
        '2023-08-29 18:30:00'
    ), (
        5,
        3,
        '2023-08-29 10:00:00',
        '2023-08-29 17:00:00'
    );

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

SELECT
    telespectador.cpf,
    telespectador.nome,
    sessao.id as id_sessao,
    count(sessao.id) as qntd
FROM externo.ingresso
    INNER JOIN externo.telespectador ON (
        telespectador.id = ingresso.telespectador_id
    )
    INNER JOIN externo.sessao ON (ingresso.sessao_id = sessao.id)
WHERE EXTRACT(
        MONTH
        FROM
            sessao.data
    ) = EXTRACT(
        MONTH
        FROM current_date
    )
GROUP BY
    sessao.id,
    telespectador.cpf,
    telespectador.nome;
