-- Consultas de Validação
-- Provam que o modelo e os relacionamentos funcionam.
-- Executar após o 01_ddl.sql e o 02_dml.sql.
USE db_eventos_plataforma;

-- 1. SELECT + WHERE (filtro simples): eventos com vendas abertas
SELECT
    e.id_evento,
    e.nome,
    e.categoria,
    e.capacidade
FROM eventos e
WHERE e.status = 'ativo';

-- 2. SELECT + WHERE (filtros combinados): compras pagas por Pix ou cartão a partir de agosto de 2026
SELECT
    c.id_compra,
    c.id_usuario,
    c.data_compra,
    c.forma_pagamento
FROM compras c
WHERE c.situacao = 'paga'
  AND c.forma_pagamento IN ('pix', 'cartao')
  AND c.data_compra >= '2026-08-01';

-- 3. INNER JOIN (3 tabelas): cada evento com seu organizador e seu local
SELECT
    e.nome AS evento,
    o.nome AS organizador,
    l.nome_local AS local,
    l.capacidade_maxima AS capacidade_local,
    e.capacidade AS capacidade_evento
FROM eventos e
INNER JOIN organizadores o ON o.id_organizador = e.id_organizador
INNER JOIN locais l ON l.id_local = e.id_local;

-- 4. INNER JOIN (5 tabelas): ingressos com comprador, evento e tipo de ingresso
SELECT
    i.id_ingresso,
    u.nome AS comprador,
    i.nome_participante AS participante,
    e.nome AS evento,
    t.nome_tipo AS tipo,
    l.numero_lote AS lote,
    i.valor_pago
FROM ingressos i
INNER JOIN compras c ON c.id_compra = i.id_compra
INNER JOIN usuarios u ON u.id_usuario = c.id_usuario
INNER JOIN lotes l ON l.id_lote = i.id_lote
INNER JOIN eventos e ON e.id_evento = l.id_evento
INNER JOIN tipos_ingressos t ON t.id_tipo_ingresso = l.id_tipo_ingresso;

-- 5. INNER JOIN (4 tabelas): check-ins com participante, sessão e evento
SELECT
    ch.id_checkin,
    i.nome_participante AS participante,
    e.nome AS evento,
    s.nome_sessao AS sessao,
    ch.data_hora_checkin
FROM checkins ch
INNER JOIN ingressos i ON i.id_ingresso = ch.id_ingresso
INNER JOIN sessoes s ON s.id_sessao = ch.id_sessao
INNER JOIN eventos e ON e.id_evento = s.id_evento;

-- 6. LEFT JOIN: usuários que ainda não fizeram nenhuma compra
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    u.data_cadastro
FROM usuarios u
LEFT JOIN compras c ON c.id_usuario = u.id_usuario
WHERE c.id_compra IS NULL;

-- 7. Tabela associativa (N:N): atrações de cada evento com o cachê combinado
SELECT
    e.nome AS evento,
    a.nome_atracao AS atracao,
    a.tipo_atracao,
    ea.cache_combinado
FROM eventos e
INNER JOIN evento_atracoes ea ON ea.id_evento = e.id_evento
INNER JOIN atracoes a ON a.id_atracao = ea.id_atracao;

-- 8. ORDER BY + LIMIT: os 5 ingressos de maior valor pago
SELECT
    i.id_ingresso,
    i.nome_participante AS participante,
    i.valor_pago
FROM ingressos i
ORDER BY i.valor_pago DESC, i.id_ingresso
LIMIT 5;
