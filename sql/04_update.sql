-- =====================================================================
-- FitControl: Sistema de Gestão para Academia
-- Script 04: atualizações (DML - UPDATE) - PostgreSQL
-- Todo UPDATE usa WHERE pela chave primária ou por um filtro preciso,
-- para alterar somente as linhas desejadas.
-- =====================================================================

-- ---------------------------------------------------------------------
-- UPDATE 1: registrar o pagamento de uma mensalidade atrasada
-- A aluna Beatriz (matrícula 7) quitou a mensalidade vencida.
-- O filtro usa a matrícula E o status, para não alterar outra cobrança.
-- ---------------------------------------------------------------------
UPDATE mensalidade
SET status          = 'paga',
    data_pagamento  = '2026-11-23',
    forma_pagamento = 'pix'
WHERE id_matricula = 7
  AND status = 'atrasada';

-- ---------------------------------------------------------------------
-- UPDATE 2: reajuste de preço do plano Mensal
-- O valor passa de R$ 149,90 para R$ 159,90. As mensalidades já
-- geradas NÃO mudam, pois guardam o valor cobrado na época
-- (registro histórico definido na normalização).
-- ---------------------------------------------------------------------
UPDATE plano
SET valor = 159.90
WHERE id_plano = 1;

-- ---------------------------------------------------------------------
-- UPDATE 3: aumento de carga na ficha de treino
-- O instrutor aumentou a carga do Supino reto (exercício 1)
-- na ficha atual do aluno Carlos (ficha 4) de 45 kg para 50 kg.
-- Como a ficha tem vários exercícios, o filtro usa as duas chaves.
-- ---------------------------------------------------------------------
UPDATE item_ficha
SET carga_kg = 50.00
WHERE id_ficha = 4
  AND id_exercicio = 1;

-- ---------------------------------------------------------------------
-- UPDATE 4: cancelar a matrícula suspensa da aluna Ana
-- Após o contato da recepção, a aluna optou por cancelar o plano.
-- O registro é mantido como histórico, apenas com a situação alterada.
-- ---------------------------------------------------------------------
UPDATE matricula
SET situacao = 'cancelada'
WHERE id_matricula = 5
  AND situacao = 'suspensa';
