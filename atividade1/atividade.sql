-- Active: 1693480327632@@127.0.0.1@5432@portal
DROP DATABASE IF EXISTS portal;

CREATE DATABASE portal;

\c portal;

CREATE TABLE
    post (
        id SERIAL PRIMARY KEY,
        titulo VARCHAR(255) NOT NULL,
        texto TEXT NOT NULL,
        data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        compartilhado BOOLEAN DEFAULT FALSE
    );

CREATE TABLE
    autor (
        id SERIAL PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        senha VARCHAR(255) NOT NULL
    );

CREATE TABLE
    post_autor (
        id SERIAL PRIMARY KEY,
        data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        post_id INTEGER REFERENCES post(id),
        autor_id INTEGER REFERENCES autor(id)
    );

CREATE TABLE
    leitor (
        id SERIAL PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        senha VARCHAR(255) NOT NULL
    );

CREATE TABLE
    endereco (
        id SERIAL PRIMARY KEY,
        bairro VARCHAR(255) NOT NULL,
        rua VARCHAR(255) NOT NULL,
        numero VARCHAR(255) NOT NULL,
        complemento VARCHAR(255),
        cep CHARACTER(9) NOT NULL,
        leitor_id INTEGER REFERENCES leitor(id)
    );

INSERT INTO post (titulo, texto, data_hora, compartilhado) VALUES
    ('Título do Post 1', 'Texto do post 1...', '2023-08-31 10:00:00', TRUE),
    ('Título do Post 2', 'Texto do post 2...', '2023-08-31 14:30:00', TRUE),
    ('Título do Post 3', 'Texto do post 3...', '2023-08-31 18:15:00', TRUE),
    ('Título do Post 4', 'Texto do post 4...', '2023-08-31 21:45:00', TRUE),
    ('Título do Post 5', 'Texto do post 5...', '2023-08-31 08:20:00', TRUE);

INSERT INTO autor (nome, email, senha) VALUES
    ('Autor 1', 'autor1@example.com', 'senha1'),
    ('Autor 2', 'autor2@example.com', 'senha2'),
    ('Autor 3', 'autor3@example.com', 'senha3'),
    ('Autor 4', 'autor4@example.com', 'senha4'),
    ('Autor 5', 'autor5@example.com', 'senha5');

INSERT INTO post_autor (data_atualizacao, post_id, autor_id) VALUES
    ('2023-08-31 10:30:00', 1, 1),
    ('2023-08-31 15:00:00', 2, 2),
    ('2023-08-31 18:45:00', 3, 3),
    ('2023-08-31 22:00:00', 4, 4),
    ('2023-08-31 08:45:00', 5, 5),
    ('2023-09-01 11:32:00', 1, 3),
    ('2023-09-01 11:32:00', 1, 5),
    ('2023-09-01 11:32:00', 5, 4),
    ('2023-08-31 08:45:00', 5, 5);

INSERT INTO leitor (nome, email, senha) VALUES
    ('Leitor 1', 'leitor1@example.com', 'senha1'),
    ('Leitor 2', 'leitor2@example.com', 'senha2'),
    ('Leitor 3', 'leitor3@example.com', 'senha3'),
    ('Leitor 4', 'leitor4@example.com', 'senha4'),
    ('Leitor 5', 'leitor5@example.com', 'senha5');

INSERT INTO endereco (bairro, rua, numero, complemento, cep, leitor_id) VALUES
    ('Bairro A', 'Rua Principal', '123', 'Apto 101', '12345-678', 1),
    ('Bairro B', 'Rua Secundária', '456', NULL, '23456-789', 2),
    ('Bairro D', 'Rua Final', '101', 'Bloco A', '45678-901', 4),
    ('Bairro E', 'Rua Inicial', '222', 'Casa 5', '56789-012', 5),
    ('Bairro B', 'Rua Secundária', '456', NULL, '23456-789', 5);

SELECT 'Leitor' Categoria, leitor.nome, leitor.email, leitor.senha, 
    CASE 
        WHEN endereco.leitor_id IS NULL THEN 'Sem endereço cadastrado'
        ELSE STRING_AGG ( CONCAT(endereco.bairro, ', ', endereco.rua, ', ', endereco.numero), '; ')
    END AS endereco_completo FROM leitor
LEFT JOIN endereco ON (leitor.id = endereco.leitor_id)
GROUP BY leitor.id, endereco.leitor_id
UNION
SELECT 'Autor' Categoria, nome, email, senha, '' "Endereço" FROM autor;

SELECT post.id AS Post, count(post_autor.post_id) AS "Qtnd de alterações" FROM post 
INNER JOIN post_autor ON post.id = post_autor.post_id
GROUP BY post.id, post_autor.post_id
ORDER BY post.id;

SELECT post.titulo AS "Título", STRING_AGG ( autor.nome, ', ' ORDER BY autor.nome) "Autores" FROM post 
INNER JOIN post_autor ON post.id = post_autor.post_id 
INNER JOIN autor ON post_autor.autor_id = autor.id
GROUP BY post.titulo
ORDER BY post.titulo;

SELECT leitor.id, leitor.nome, leitor.email,
    CASE 
        WHEN endereco.leitor_id IS NULL THEN 'Sem endereço cadastrado'
        ELSE STRING_AGG ( CONCAT(endereco.bairro, ', ', endereco.rua, ', ', endereco.numero), '; ')
    END AS "Endereco completo"
FROM leitor 
LEFT JOIN endereco ON leitor.id = endereco.leitor_id
GROUP BY leitor.id, endereco.leitor_id
ORDER BY leitor.id;