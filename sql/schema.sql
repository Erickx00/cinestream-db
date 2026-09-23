DROP TABLE IF EXISTS Episodio CASCADE;
DROP TABLE IF EXISTS ObraProfissional CASCADE;
DROP TABLE IF EXISTS ObraGenero CASCADE;
DROP TABLE IF EXISTS Visualizacao CASCADE;
DROP TABLE IF EXISTS Profissional CASCADE;
DROP TABLE IF EXISTS Genero CASCADE;
DROP TABLE IF EXISTS Obra CASCADE;
DROP TABLE IF EXISTS Perfil CASCADE;
DROP TABLE IF EXISTS ClassificacaoMaturidade CASCADE;
DROP TABLE IF EXISTS Dispositivo CASCADE;
DROP TABLE IF EXISTS Fatura CASCADE;
DROP TABLE IF EXISTS StatusCobranca CASCADE;
DROP TABLE IF EXISTS HistoricoAssinatura CASCADE;
DROP TABLE IF EXISTS Plano CASCADE;
DROP TABLE IF EXISTS QualidadeResolucao CASCADE;
DROP TABLE IF EXISTS Assinante CASCADE;


CREATE TABLE assinante (
    id_assinante INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    conta_ativa BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE qualidade_resolucao (
    id_qualidade INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao VARCHAR(20) NOT NULL,

    CONSTRAINT chk_qualidade
        CHECK (descricao IN ('SD', 'FULL-HD', '4K'))
);


CREATE TABLE plano (
    id_plano INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_comercial VARCHAR(100) NOT NULL,
    max_telas SMALLINT NOT NULL,
    id_qualidade INT NOT NULL,

    CONSTRAINT fk_plano_qualidade
        FOREIGN KEY (id_qualidade)
        REFERENCES qualidade_resolucao(id_qualidade)
);


CREATE TABLE historico_assinatura (
    id_assinante INT NOT NULL,
    id_plano INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    valor_cobrado NUMERIC(10,2) NOT NULL,

    CONSTRAINT pk_historico_assinatura
        PRIMARY KEY (id_assinante, id_plano, data_inicio),

    CONSTRAINT fk_hist_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES assinante(id_assinante)
        ON DELETE CASCADE,

    CONSTRAINT fk_hist_plano
        FOREIGN KEY (id_plano)
        REFERENCES plano(id_plano)
);


CREATE TABLE status_cobranca (
    id_status INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,

    CONSTRAINT chk_status_cobranca
        CHECK (nome IN ('PENDENTE', 'PAGA', 'ATRASADA', 'ESTORNADA'))
);


CREATE TABLE fatura (
    id_fatura INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_emissao DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento DATE,
    valor_total NUMERIC(10,2) NOT NULL,
    id_assinante INT NOT NULL,
    id_status INT NOT NULL,

    CONSTRAINT fk_fatura_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES assinante(id_assinante)
        ON DELETE CASCADE,

    CONSTRAINT fk_fatura_status
        FOREIGN KEY (id_status)
        REFERENCES status_cobranca(id_status)
);


CREATE TABLE dispositivo (
    id_dispositivo INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    endereco_mac CHAR(17) NOT NULL UNIQUE,
    sistema_operacional VARCHAR(50) NOT NULL,
    id_assinante INT NOT NULL,

    CONSTRAINT fk_dispositivo_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES assinante(id_assinante)
        ON DELETE CASCADE
);


CREATE TABLE classificacao_maturidade (
    id_classificacao INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao VARCHAR(20) NOT NULL,

    CONSTRAINT chk_classificacao_maturidade
        CHECK (descricao IN ('INFANTIL', 'ADOLESCENTE', 'ADULTO'))
);


CREATE TABLE perfil (
    id_assinante INT NOT NULL,
    numero_sequencial INT NOT NULL,
    nome_exibicao VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(255),
    id_classificacao INT NOT NULL,

    CONSTRAINT pk_perfil
        PRIMARY KEY (id_assinante, numero_sequencial),

    CONSTRAINT uq_perfil_nome
        UNIQUE (id_assinante, nome_exibicao),

    CONSTRAINT fk_perfil_assinante
        FOREIGN KEY (id_assinante)
        REFERENCES assinante(id_assinante)
        ON DELETE CASCADE,

    CONSTRAINT fk_perfil_classificacao
        FOREIGN KEY (id_classificacao)
        REFERENCES classificacao_maturidade(id_classificacao)
);


CREATE TABLE obra (
    id_obra INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    sinopse TEXT NOT NULL,
    ano_lancamento SMALLINT NOT NULL,
    idade_minima_recomendada SMALLINT NOT NULL
);


CREATE TABLE genero (
    id_genero INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);


CREATE TABLE profissional (
    id_profissional INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_artistico VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    pais_origem VARCHAR(100) NOT NULL
);


CREATE TABLE visualizacao (
    id_visualizacao INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data_hora TIMESTAMP NOT NULL,
    porcentagem_assistida NUMERIC(5,2) NOT NULL,

    id_dispositivo INT,
    id_assinante INT NOT NULL,
    numero_sequencial INT NOT NULL,
    id_obra INT NOT NULL,

    CONSTRAINT chk_porcentagem_assistida
        CHECK (
            porcentagem_assistida >= 0
            AND porcentagem_assistida <= 100
        ),

    CONSTRAINT fk_visualizacao_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivo(id_dispositivo)
        ON DELETE SET NULL,

    CONSTRAINT fk_visualizacao_obra
        FOREIGN KEY (id_obra)
        REFERENCES obra(id_obra)
        ON DELETE CASCADE,

    CONSTRAINT fk_visualizacao_perfil
        FOREIGN KEY (id_assinante, numero_sequencial)
        REFERENCES perfil(id_assinante, numero_sequencial)
        ON DELETE CASCADE
);


CREATE TABLE obra_genero (
    id_obra INT NOT NULL,
    id_genero INT NOT NULL,

    CONSTRAINT pk_obra_genero
        PRIMARY KEY (id_obra, id_genero),

    CONSTRAINT fk_obra_genero_obra
        FOREIGN KEY (id_obra)
        REFERENCES obra(id_obra)
        ON DELETE CASCADE,

    CONSTRAINT fk_obra_genero_genero
        FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero)
        ON DELETE CASCADE
);


CREATE TABLE obra_profissional (
    id_profissional INT NOT NULL,
    id_obra INT NOT NULL,
    funcao VARCHAR(50) NOT NULL,

    CONSTRAINT pk_obra_profissional
        PRIMARY KEY (id_profissional, id_obra, funcao),

    CONSTRAINT chk_funcao_profissional
        CHECK (funcao IN ('ATOR', 'DIRETOR')),

    CONSTRAINT fk_obra_profissional_profissional
        FOREIGN KEY (id_profissional)
        REFERENCES profissional(id_profissional)
        ON DELETE CASCADE,

    CONSTRAINT fk_obra_profissional_obra
        FOREIGN KEY (id_obra)
        REFERENCES obra(id_obra)
        ON DELETE CASCADE
);


CREATE TABLE episodio (
    id_obra INT NOT NULL,
    numero_temporada SMALLINT NOT NULL,
    numero_capitulo SMALLINT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    duracao SMALLINT NOT NULL,

    CONSTRAINT pk_episodio
        PRIMARY KEY (id_obra, numero_temporada, numero_capitulo),

    CONSTRAINT fk_episodio_obra
        FOREIGN KEY (id_obra)
        REFERENCES obra(id_obra)
        ON DELETE CASCADE
);
