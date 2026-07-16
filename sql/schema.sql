-- =========================================================
-- CineStream - Plataforma de Entretenimento Digital
-- Script de criação das tabelas (DDL)
-- Banco de Dados I - IFPB - 2026.1 A
-- =========================================================

CREATE TABLE Assinante (
    id_assinante INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    conta_ativa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE QualidadeResolucao (
    id_qualidade INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao VARCHAR(20) NOT NULL
        CHECK (descricao IN ('SD', 'FULL-HD', '4K'))
);

CREATE TABLE Plano (
    id_plano INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_comercial VARCHAR(100) NOT NULL,
    max_telas SMALLINT NOT NULL,
    id_qualidade INT NOT NULL,
    CONSTRAINT fk_plano_qualidade
        FOREIGN KEY (id_qualidade)
        REFERENCES QualidadeResolucao(id_qualidade)
);

CREATE TABLE HistoricoAssinatura (
    id_assinante INT,
    id_plano INT,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    valor_cobrado NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (id_assinante, id_plano, data_inicio),
    CONSTRAINT fk_hist_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES Assinante(id_assinante)
        ON DELETE CASCADE,
    CONSTRAINT fk_hist_plano
        FOREIGN KEY (id_plano)
        REFERENCES Plano(id_plano)
);

CREATE TABLE StatusCobranca (
    id_status INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(20) NOT NULL
        CHECK (nome IN ('PENDENTE', 'PAGA', 'ATRASADA', 'ESTORNADA'))
);

CREATE TABLE Fatura (
    id_fatura INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_emissao DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    valor_total NUMERIC(10,2) NOT NULL,
    id_assinante INT NOT NULL,
    id_status INT NOT NULL,
    CONSTRAINT fk_fatura_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES Assinante(id_assinante)
        ON DELETE CASCADE,
    CONSTRAINT fk_fatura_status
        FOREIGN KEY (id_status)
        REFERENCES StatusCobranca(id_status)
);

CREATE TABLE Dispositivo (
    id_dispositivo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    endereco_mac CHAR(17) NOT NULL UNIQUE,
    sistema_operacional VARCHAR(50) NOT NULL,
    id_assinante INT NOT NULL,
    CONSTRAINT fk_dispositivo_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES Assinante(id_assinante)
        ON DELETE CASCADE
);

CREATE TABLE ClassificacaoMaturidade (
    id_classificacao INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao VARCHAR(20) NOT NULL
        CHECK (descricao IN ('INFANTIL', 'ADOLESCENTE', 'ADULTO'))
);

CREATE TABLE Perfil (
    id_assinante INT,
    numero_sequencial INT,
    nome_exibicao VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(255),
    id_classificacao INT NOT NULL,
    PRIMARY KEY (id_assinante, numero_sequencial),
    UNIQUE (id_assinante, nome_exibicao),
    CONSTRAINT fk_perfil_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES Assinante(id_assinante)
        ON DELETE CASCADE,
    CONSTRAINT fk_perfil_classificacao
        FOREIGN KEY (id_classificacao)
        REFERENCES ClassificacaoMaturidade(id_classificacao)
);

CREATE TABLE Obra (
    id_obra INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    sinopse TEXT NOT NULL,
    ano_lancamento SMALLINT NOT NULL,
    idade_minima_recomendada SMALLINT NOT NULL
);

CREATE TABLE Visualizacao (
    id_visualizacao INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_hora TIMESTAMP NOT NULL,
    porcentagem_assistida NUMERIC(5,2) NOT NULL
        CHECK (porcentagem_assistida >= 0 AND porcentagem_assistida <= 100),
    id_dispositivo INT,
    id_assinante INT NOT NULL,
    numero_sequencial INT NOT NULL,
    id_obra INT NOT NULL,
    CONSTRAINT fk_visualizacao_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES Dispositivo(id_dispositivo)
        ON DELETE SET NULL,
    CONSTRAINT fk_visualizacao_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
        ON DELETE CASCADE,
    CONSTRAINT fk_visualizacao_perfil
        FOREIGN KEY (id_assinante, numero_sequencial)
        REFERENCES Perfil(id_assinante, numero_sequencial)
        ON DELETE CASCADE
);

CREATE TABLE Genero (
    id_genero INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE ObraGenero (
    id_obra INT,
    id_genero INT,
    PRIMARY KEY (id_obra, id_genero),
    CONSTRAINT fk_obra_genero_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
        ON DELETE CASCADE,
    CONSTRAINT fk_obra_genero_genero
        FOREIGN KEY (id_genero)
        REFERENCES Genero(id_genero)
        ON DELETE CASCADE
);

CREATE TABLE Profissional (
    id_profissional INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_artistico VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    pais_origem VARCHAR(100) NOT NULL
);

CREATE TABLE ObraProfissional (
    id_profissional INT,
    id_obra INT,
    funcao VARCHAR(50) NOT NULL
        CHECK (funcao IN ('ATOR', 'DIRETOR')),
    PRIMARY KEY (id_profissional, id_obra, funcao),
    CONSTRAINT fk_obra_profissional_profissional
        FOREIGN KEY (id_profissional)
        REFERENCES Profissional(id_profissional)
        ON DELETE CASCADE,
    CONSTRAINT fk_obra_profissional_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
        ON DELETE CASCADE
);

CREATE TABLE Episodio (
    id_obra INT,
    numero_temporada SMALLINT NOT NULL,
    numero_capitulo SMALLINT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    duracao SMALLINT NOT NULL,
    PRIMARY KEY (id_obra, numero_temporada, numero_capitulo),
    CONSTRAINT fk_episodio_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
        ON DELETE CASCADE
);
