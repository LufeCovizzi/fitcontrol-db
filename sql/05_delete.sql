-- =====================================================================
-- FitControl: Sistema de Gestão para Academia
-- Script 05: exclusões (DML - DELETE) - PostgreSQL
-- Todo DELETE usa WHERE com filtro preciso. Quando o registro possui
-- dependentes (chaves estrangeiras), os filhos são excluídos antes.
-- =====================================================================

-- ---------------------------------------------------------------------
-- DELETE 1: limpeza de check-ins antigos
-- Remove os registros de entrada anteriores a 23/10/2026
-- (mais de 30 dias). CHECKIN não é referenciada por nenhuma
-- outra tabela, então a exclusão é segura.
-- ---------------------------------------------------------------------
DELETE FROM checkin
WHERE data_hora < '2026-10-23';

-- ---------------------------------------------------------------------
-- DELETE 2: remover um exercício da ficha de treino
-- O instrutor retirou a Puxada frontal (exercício 5) da ficha do
-- aluno João (ficha 1). Apenas o item é excluído: o exercício
-- continua no catálogo e a ficha continua existindo.
-- ---------------------------------------------------------------------
DELETE FROM item_ficha
WHERE id_ficha = 1
  AND id_exercicio = 5;

-- ---------------------------------------------------------------------
-- DELETE 3: excluir um cadastro feito por engano
-- O aluno Lucas (aluno 7) foi cadastrado em duplicidade e precisa
-- ser removido. Como ele possui registros dependentes, a exclusão
-- segue a ordem inversa das chaves estrangeiras: primeiro os
-- check-ins e as mensalidades, depois a matrícula e, por fim, o aluno.
-- Excluir o aluno diretamente geraria erro de violação de FK.
-- ---------------------------------------------------------------------
DELETE FROM checkin
WHERE id_aluno = 7;

DELETE FROM mensalidade
WHERE id_matricula IN (SELECT id_matricula FROM matricula WHERE id_aluno = 7);

DELETE FROM matricula
WHERE id_aluno = 7;

DELETE FROM aluno
WHERE id_aluno = 7;
