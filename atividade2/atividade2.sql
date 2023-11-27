DROP DATABASE IF EXISTS atividade2;

CREATE DATABASE atividade2;

\c atividade2;

CREATE TABLE
    usuario (
        id SERIAL PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        senha VARCHAR(255) NOT NULL
    );

CREATE TABLE
    anotacoes (
        id SERIAL PRIMARY KEY,
        titulo VARCHAR(255) NOT NULL,
        texto TEXT NOT NULL,
        cor VARCHAR(7) NOT NULL,
        atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        lixeira BOOLEAN DEFAULT FALSE,
        nome_usuario VARCHAR(255),
        usuario_id INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuario(id)
    );

-- Inserir dados na tabela 'usuario'

INSERT INTO
    usuario (nome, email, senha)
VALUES (
        'João Silva',
        'joao@example.com',
        'senha123'
    ), (
        'Maria Souza',
        'maria@example.com',
        'senha456'
    ), (
        'Pedro Oliveira',
        'pedro@example.com',
        'senha789'
    );

-- Inserir dados na tabela 'anotacoes'

INSERT INTO
    anotacoes (
        titulo,
        texto,
        cor,
        nome_usuario,
        usuario_id
    )
VALUES (
        'Compras',
        'Comprar leite, ovos e pão',
        '#ff0000',
        'João Silva',
        1
    ), (
        'Reunião',
        'Reunião marcada para as 14h',
        '#00ff00',
        'Maria Souza',
        2
    ), (
        'Tarefas',
        'Realizar tarefas do projeto',
        '#0000ff',
        'Pedro Oliveira',
        3
    ), (
        'Lista de Tarefas',
        'Criar lista de tarefas para a semana',
        '#ffa500',
        'João Silva',
        1
    ), (
        'Compromisso',
        'Compromisso agendado para amanhã cedo',
        '#800080',
        'Maria Souza',
        2
    ), (
        'Planejamento',
        'Iniciar planejamento do projeto',
        '#008000',
        'Pedro Oliveira',
        3
    ), (
        'Estudo',
        'Estudar para a prova de matemática',
        '#800000',
        'João Silva',
        1
    ), (
        'Projeto',
        'Desenvolver a parte inicial do projeto',
        '#000080',
        'Maria Souza',
        2
    ), (
        'Exercícios',
        'Fazer exercícios de programação',
        '#008080',
        'Pedro Oliveira',
        3
    ), (
        'Leitura',
        'Ler o novo livro recomendado',
        '#ff00ff',
        'João Silva',
        1
    );