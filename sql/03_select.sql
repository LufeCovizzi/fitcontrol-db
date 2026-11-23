-- =====================================================================
-- FitControl: Sistema de Gestão para Academia
-- Script 03: consultas (DML - SELECT) - PostgreSQL
-- =====================================================================

-- ---------------------------------------------------------------------
-- Consulta 1: alunos inadimplentes
-- Lista os alunos com mensalidade atrasada, com o plano contratado,
-- o valor devido e quantos dias de atraso existem.
-- JOIN de 4 tabelas: aluno -> matricula -> plano / mensalidade.
-- ---------------------------------------------------------------------
SELECT a.nome                               AS aluno,
       a.telefone,
       p.nome                               AS plano,
       me.data_vencimento,
       me.valor                             AS valor_devido,
       DATE '2026-11-23' - me.data_vencimento AS dias_atraso
FROM aluno a
INNER JOIN matricula   m  ON m.id_aluno      = a.id_aluno
INNER JOIN plano       p  ON p.id_plano      = m.id_plano
INNER JOIN mensalidade me ON me.id_matricula = m.id_matricula
WHERE me.status = 'atrasada'
ORDER BY dias_atraso DESC;

-- ---------------------------------------------------------------------
-- Consulta 2: horários de maior movimento (top 3)
-- Agrupa os check-ins pela hora de entrada e mostra as 3 faixas
-- de horário com mais entradas.
-- ---------------------------------------------------------------------
SELECT EXTRACT(HOUR FROM c.data_hora) AS hora,
       COUNT(*)                       AS total_checkins
FROM checkin c
GROUP BY EXTRACT(HOUR FROM c.data_hora)
ORDER BY total_checkins DESC, hora
LIMIT 3;

-- ---------------------------------------------------------------------
-- Consulta 3: ficha de treino ativa de cada aluno
-- Junta 5 tabelas para montar a ficha completa: aluno, instrutor
-- responsável e exercícios com séries, repetições e carga.
-- ---------------------------------------------------------------------
SELECT a.nome            AS aluno,
       f.nome            AS instrutor,
       ft.objetivo,
       e.nome            AS exercicio,
       e.grupo_muscular,
       i.series,
       i.repeticoes,
       i.carga_kg
FROM ficha_treino ft
INNER JOIN aluno       a ON a.id_aluno       = ft.id_aluno
INNER JOIN funcionario f ON f.id_funcionario = ft.id_instrutor
INNER JOIN item_ficha  i ON i.id_ficha       = ft.id_ficha
INNER JOIN exercicio   e ON e.id_exercicio   = i.id_exercicio
WHERE ft.ativa = TRUE
ORDER BY a.nome, e.grupo_muscular;

-- ---------------------------------------------------------------------
-- Consulta 4: alunos com risco de evasão
-- Conta os check-ins dos últimos 30 dias de cada aluno, incluindo
-- quem não teve nenhuma entrada (LEFT JOIN), e mostra os 3 alunos
-- menos frequentes.
-- ---------------------------------------------------------------------
SELECT a.nome,
       COUNT(c.id_checkin) AS checkins_30_dias
FROM aluno a
LEFT JOIN checkin c
       ON c.id_aluno = a.id_aluno
      AND c.data_hora >= DATE '2026-11-23' - INTERVAL '30 days'
GROUP BY a.id_aluno, a.nome
ORDER BY checkins_30_dias ASC, a.nome
LIMIT 3;

-- ---------------------------------------------------------------------
-- Consulta 5: faturamento por plano
-- Soma apenas as mensalidades efetivamente pagas, agrupadas
-- pelo plano de cada matrícula.
-- ---------------------------------------------------------------------
SELECT p.nome            AS plano,
       COUNT(me.id_mensalidade) AS pagamentos,
       SUM(me.valor)     AS total_recebido
FROM plano p
INNER JOIN matricula   m  ON m.id_plano      = p.id_plano
INNER JOIN mensalidade me ON me.id_matricula = m.id_matricula
WHERE me.status = 'paga'
GROUP BY p.nome
ORDER BY total_recebido DESC;
