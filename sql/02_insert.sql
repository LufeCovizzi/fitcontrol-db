-- =====================================================================
-- FitControl: Sistema de Gestão para Academia
-- Script 02: povoamento das tabelas (DML - INSERT) - PostgreSQL
-- Ordem de inserção: primeiro as tabelas independentes, depois as que
-- possuem chave estrangeira, para que toda referência já exista.
-- Os ids são gerados automaticamente (SERIAL) na ordem de inserção.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. PLANO: modalidades oferecidas pela academia (ids 1 a 4)
-- ---------------------------------------------------------------------
INSERT INTO plano (nome, duracao_meses, valor) VALUES
    ('Mensal',     1, 149.90),
    ('Trimestral', 3, 389.70),
    ('Semestral',  6, 719.40),
    ('Anual',     12, 1318.80);

-- ---------------------------------------------------------------------
-- 2. FUNCIONARIO: equipe da academia (ids 1 a 5)
--    O cargo define as permissões de cada um no sistema.
-- ---------------------------------------------------------------------
INSERT INTO funcionario (cpf, nome, cargo, telefone, email) VALUES
    ('11122233344', 'Fernanda Rocha',   'gestor',        '17991110001', 'fernanda@fitcontrol.com'),
    ('22233344455', 'Juliana Martins',  'recepcionista', '17991110002', 'juliana@fitcontrol.com'),
    ('33344455566', 'Rafael Oliveira',  'recepcionista', '17991110003', 'rafael@fitcontrol.com'),
    ('44455566677', 'Bruno Carvalho',   'instrutor',     '17991110004', 'bruno@fitcontrol.com'),
    ('55566677788', 'Camila Ferreira',  'instrutor',     '17991110005', 'camila@fitcontrol.com');

-- ---------------------------------------------------------------------
-- 3. ALUNO: clientes da academia (ids 1 a 8)
--    E-mail e caminhos de arquivos são opcionais (podem ser NULL).
-- ---------------------------------------------------------------------
INSERT INTO aluno (cpf, nome, data_nascimento, telefone, email, foto_url, atestado_url) VALUES
    ('10020030040', 'João Silva',      '1995-03-14', '17992220001', 'joao.silva@email.com',   'fotos/aluno_1.jpg', 'atestados/aluno_1.pdf'),
    ('20030040050', 'Maria Souza',     '1990-07-22', '17992220002', 'maria.souza@email.com',  'fotos/aluno_2.jpg', NULL),
    ('30040050060', 'Carlos Lima',     '1988-11-05', '17992220003', 'carlos.lima@email.com',  NULL,                'atestados/aluno_3.pdf'),
    ('40050060070', 'Ana Pereira',     '2000-01-30', '17992220004', NULL,                     NULL,                NULL),
    ('50060070080', 'Pedro Santos',    '1998-09-18', '17992220005', 'pedro.santos@email.com', 'fotos/aluno_5.jpg', 'atestados/aluno_5.pdf'),
    ('60070080090', 'Beatriz Costa',   '1993-04-09', '17992220006', 'bia.costa@email.com',    NULL,                NULL),
    ('70080090010', 'Lucas Almeida',   '2002-12-01', '17992220007', 'lucas.almeida@email.com',NULL,                NULL),
    ('80090010020', 'Larissa Gomes',   '1985-06-27', '17992220008', 'larissa.gomes@email.com','fotos/aluno_8.jpg', 'atestados/aluno_8.pdf');

-- ---------------------------------------------------------------------
-- 4. EXERCICIO: catálogo de exercícios (ids 1 a 10)
--    Cada exercício é cadastrado uma única vez (resultado da 2FN).
-- ---------------------------------------------------------------------
INSERT INTO exercicio (nome, grupo_muscular) VALUES
    ('Supino reto',        'Peito'),
    ('Crucifixo',          'Peito'),
    ('Agachamento livre',  'Pernas'),
    ('Leg press',          'Pernas'),
    ('Puxada frontal',     'Costas'),
    ('Remada curvada',     'Costas'),
    ('Desenvolvimento',    'Ombros'),
    ('Rosca direta',       'Bíceps'),
    ('Tríceps corda',      'Tríceps'),
    ('Esteira',            'Cardio');

-- ---------------------------------------------------------------------
-- 5. MATRICULA: vínculo entre aluno e plano (ids 1 a 9)
--    Depende de ALUNO, PLANO e FUNCIONARIO (recepcionista que registrou).
--    Cenários: matrículas ativas, uma suspensa (inadimplência) e uma
--    cancelada que foi renovada (aluna 2 com duas matrículas).
-- ---------------------------------------------------------------------
INSERT INTO matricula (id_aluno, id_plano, id_funcionario, data_inicio, data_vencimento, situacao) VALUES
    (1, 1, 2, '2026-11-01', '2026-12-01', 'ativa'),      -- 1: João, Mensal
    (2, 1, 2, '2026-05-10', '2026-06-10', 'cancelada'),  -- 2: Maria, Mensal antigo (cancelado)
    (2, 2, 3, '2026-09-10', '2026-12-10', 'ativa'),      -- 3: Maria, Trimestral (renovação)
    (3, 4, 2, '2026-02-01', '2027-02-01', 'ativa'),      -- 4: Carlos, Anual
    (4, 1, 3, '2026-10-10', '2026-11-10', 'suspensa'),   -- 5: Ana, Mensal (inadimplente)
    (5, 3, 2, '2026-08-01', '2027-02-01', 'ativa'),      -- 6: Pedro, Semestral
    (6, 2, 3, '2026-10-01', '2027-01-01', 'ativa'),      -- 7: Beatriz, Trimestral
    (7, 1, 2, '2026-11-15', '2026-12-15', 'ativa'),      -- 8: Lucas, Mensal
    (8, 4, 3, '2026-03-01', '2027-03-01', 'ativa');      -- 9: Larissa, Anual

-- ---------------------------------------------------------------------
-- 6. MENSALIDADE: cobranças geradas por cada matrícula
--    O valor fica registrado no momento da cobrança (registro histórico).
--    Cenários: pagas, pendentes (ainda no prazo) e atrasadas.
-- ---------------------------------------------------------------------
INSERT INTO mensalidade (id_matricula, data_vencimento, valor, data_pagamento, forma_pagamento, status, comprovante_url) VALUES
    -- Matrícula 1 (João, Mensal): paga
    (1, '2026-11-01', 149.90,  '2026-11-01', 'pix',      'paga',     'comprovantes/m1_nov.pdf'),
    -- Matrícula 2 (Maria, Mensal antigo): paga antes do cancelamento
    (2, '2026-05-10', 139.90,  '2026-05-10', 'cartao',   'paga',     NULL),
    -- Matrícula 3 (Maria, Trimestral): parcela única paga
    (3, '2026-09-10', 389.70,  '2026-09-10', 'cartao',   'paga',     NULL),
    -- Matrícula 4 (Carlos, Anual): parcela única paga
    (4, '2026-02-01', 1318.80, '2026-02-01', 'pix',      'paga',     'comprovantes/m4_anual.pdf'),
    -- Matrícula 5 (Ana, Mensal): vencida e não paga
    (5, '2026-10-10', 149.90,  '2026-10-12', 'dinheiro', 'paga',     NULL),
    (5, '2026-11-10', 149.90,  NULL,         NULL,       'atrasada', NULL),
    -- Matrícula 6 (Pedro, Semestral): parcela única paga
    (6, '2026-08-01', 719.40,  '2026-08-01', 'cartao',   'paga',     NULL),
    -- Matrícula 7 (Beatriz, Trimestral): parcela única ainda atrasada
    (7, '2026-10-01', 389.70,  NULL,         NULL,       'atrasada', NULL),
    -- Matrícula 8 (Lucas, Mensal): dentro do prazo
    (8, '2026-11-25', 149.90,  NULL,         NULL,       'pendente', NULL),
    -- Matrícula 9 (Larissa, Anual): parcela única paga
    (9, '2026-03-01', 1318.80, '2026-03-01', 'pix',      'paga',     'comprovantes/m9_anual.pdf');

-- ---------------------------------------------------------------------
-- 7. CHECKIN: entradas dos alunos na academia
--    Datas e horários variados para permitir análises de frequência
--    e de horário de pico (concentração por volta das 18h).
-- ---------------------------------------------------------------------
INSERT INTO checkin (id_aluno, data_hora) VALUES
    (1, '2026-11-16 07:05'), (1, '2026-11-17 18:30'), (1, '2026-11-18 18:40'),
    (1, '2026-11-19 07:10'), (1, '2026-11-20 18:35'), (1, '2026-11-23 18:20'),
    (2, '2026-11-17 18:15'), (2, '2026-11-19 18:25'), (2, '2026-11-21 10:00'),
    (3, '2026-11-16 06:30'), (3, '2026-11-17 06:35'), (3, '2026-11-18 06:30'),
    (3, '2026-11-19 06:40'), (3, '2026-11-20 06:30'), (3, '2026-11-23 06:35'),
    (4, '2026-11-02 19:00'),
    (5, '2026-11-17 18:45'), (5, '2026-11-18 12:10'), (5, '2026-11-20 18:50'),
    (6, '2026-10-20 18:30'),
    (7, '2026-11-16 18:10'), (7, '2026-11-18 18:30'), (7, '2026-11-20 18:20'),
    (8, '2026-11-17 09:00'), (8, '2026-11-19 09:15'), (8, '2026-11-21 09:05');

-- ---------------------------------------------------------------------
-- 8. FICHA_TREINO: fichas elaboradas pelos instrutores (ids 1 a 6)
--    O aluno 3 possui uma ficha antiga (inativa) e uma atual,
--    preservando o histórico de evolução.
-- ---------------------------------------------------------------------
INSERT INTO ficha_treino (id_aluno, id_instrutor, data_criacao, objetivo, ativa) VALUES
    (1, 4, '2026-11-01', 'Hipertrofia',     TRUE),   -- 1: João, instrutor Bruno
    (2, 5, '2026-09-12', 'Emagrecimento',   TRUE),   -- 2: Maria, instrutora Camila
    (3, 4, '2026-08-01', 'Hipertrofia',     FALSE),  -- 3: Carlos, ficha antiga
    (3, 4, '2026-11-03', 'Hipertrofia',     TRUE),   -- 4: Carlos, ficha atual
    (5, 5, '2026-08-02', 'Condicionamento', TRUE),   -- 5: Pedro, instrutora Camila
    (8, 5, '2026-03-02', 'Emagrecimento',   TRUE);   -- 6: Larissa, instrutora Camila

-- ---------------------------------------------------------------------
-- 9. ITEM_FICHA: exercícios de cada ficha
--    Depende de FICHA_TREINO e EXERCICIO.
--    A carga do supino do aluno 3 evolui de 30 kg para 45 kg.
-- ---------------------------------------------------------------------
INSERT INTO item_ficha (id_ficha, id_exercicio, series, repeticoes, carga_kg, observacao) VALUES
    -- Ficha 1 (João)
    (1, 1, 4, 10, 40.00, NULL),
    (1, 5, 4, 10, 45.00, NULL),
    (1, 3, 4, 12, 50.00, 'Manter a coluna neutra durante o movimento'),
    -- Ficha 2 (Maria)
    (2, 10, 1, 1, NULL,  '30 minutos em ritmo moderado'),
    (2, 4,  3, 15, 80.00, NULL),
    (2, 9,  3, 15, 15.00, NULL),
    -- Ficha 3 (Carlos, antiga)
    (3, 1, 3, 12, 30.00, NULL),
    (3, 6, 3, 12, 25.00, NULL),
    -- Ficha 4 (Carlos, atual)
    (4, 1, 4, 8,  45.00, 'Aumentar a carga gradualmente'),
    (4, 6, 4, 10, 35.00, NULL),
    (4, 7, 3, 10, 20.00, NULL),
    -- Ficha 5 (Pedro)
    (5, 3, 3, 15, 30.00, NULL),
    (5, 8, 3, 12, 12.00, NULL),
    (5, 10, 1, 1, NULL,  '20 minutos de intervalado'),
    -- Ficha 6 (Larissa)
    (6, 2, 3, 12, 10.00, NULL),
    (6, 4, 3, 15, 70.00, 'Cuidado com o joelho esquerdo');
