-- =====================================================================
-- FitControl: Sistema de Gestão para Academia
-- Script 01: criação das tabelas (DDL) - PostgreSQL
-- Banco de dados: fitcontrol_db
-- =====================================================================

-- ---------------------------------------------------------------------
-- Tabelas independentes (não possuem chave estrangeira)
-- ---------------------------------------------------------------------

CREATE TABLE plano (
    id_plano       SERIAL PRIMARY KEY,
    nome           VARCHAR(50)   NOT NULL UNIQUE,
    duracao_meses  INT           NOT NULL CHECK (duracao_meses > 0),
    valor          NUMERIC(10,2) NOT NULL CHECK (valor > 0)
);

CREATE TABLE aluno (
    id_aluno         SERIAL PRIMARY KEY,
    cpf              CHAR(11)     NOT NULL UNIQUE,
    nome             VARCHAR(100) NOT NULL,
    data_nascimento  DATE         NOT NULL,
    telefone         VARCHAR(15)  NOT NULL,
    email            VARCHAR(100),
    foto_url         VARCHAR(255),
    atestado_url     VARCHAR(255)
);

CREATE TABLE funcionario (
    id_funcionario  SERIAL PRIMARY KEY,
    cpf             CHAR(11)     NOT NULL UNIQUE,
    nome            VARCHAR(100) NOT NULL,
    cargo           VARCHAR(20)  NOT NULL
                    CHECK (cargo IN ('recepcionista', 'instrutor', 'gestor')),
    telefone        VARCHAR(15)  NOT NULL,
    email           VARCHAR(100) NOT NULL
);

CREATE TABLE exercicio (
    id_exercicio    SERIAL PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL UNIQUE,
    grupo_muscular  VARCHAR(50)  NOT NULL
);

-- ---------------------------------------------------------------------
-- Tabelas dependentes (possuem chave estrangeira)
-- ---------------------------------------------------------------------

CREATE TABLE matricula (
    id_matricula     SERIAL PRIMARY KEY,
    id_aluno         INT         NOT NULL REFERENCES aluno (id_aluno),
    id_plano         INT         NOT NULL REFERENCES plano (id_plano),
    id_funcionario   INT         NOT NULL REFERENCES funcionario (id_funcionario),
    data_inicio      DATE        NOT NULL,
    data_vencimento  DATE        NOT NULL,
    situacao         VARCHAR(15) NOT NULL DEFAULT 'ativa'
                     CHECK (situacao IN ('ativa', 'suspensa', 'cancelada')),
    CHECK (data_vencimento > data_inicio)
);

CREATE TABLE mensalidade (
    id_mensalidade   SERIAL PRIMARY KEY,
    id_matricula     INT           NOT NULL REFERENCES matricula (id_matricula),
    data_vencimento  DATE          NOT NULL,
    valor            NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento   DATE,
    forma_pagamento  VARCHAR(20)
                     CHECK (forma_pagamento IN ('dinheiro', 'cartao', 'pix')),
    status           VARCHAR(15)   NOT NULL DEFAULT 'pendente'
                     CHECK (status IN ('pendente', 'paga', 'atrasada')),
    comprovante_url  VARCHAR(255)
);

CREATE TABLE checkin (
    id_checkin  SERIAL PRIMARY KEY,
    id_aluno    INT       NOT NULL REFERENCES aluno (id_aluno),
    data_hora   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ficha_treino (
    id_ficha      SERIAL PRIMARY KEY,
    id_aluno      INT         NOT NULL REFERENCES aluno (id_aluno),
    id_instrutor  INT         NOT NULL REFERENCES funcionario (id_funcionario),
    data_criacao  DATE        NOT NULL,
    objetivo      VARCHAR(50) NOT NULL,
    ativa         BOOLEAN     NOT NULL DEFAULT TRUE
);

CREATE TABLE item_ficha (
    id_item       SERIAL PRIMARY KEY,
    id_ficha      INT          NOT NULL REFERENCES ficha_treino (id_ficha),
    id_exercicio  INT          NOT NULL REFERENCES exercicio (id_exercicio),
    series        INT          NOT NULL CHECK (series > 0),
    repeticoes    INT          NOT NULL CHECK (repeticoes > 0),
    carga_kg      NUMERIC(5,2) CHECK (carga_kg >= 0),
    observacao    TEXT,
    UNIQUE (id_ficha, id_exercicio)  -- o mesmo exercício não se repete na ficha
);
