-- Consultas avançadas
-- Responder perguntas de negócio com SQL mais elaborado

USE db_eventos_plataforma;

-- Pergunta 1: Qual a receita total de ingressos e a receita gerada pela taxa da plataforma (10%) por organizador, incluindo seus dados de contato?
-- Por que importa: A taxa de 10% é o faturamento da Palco Aberto, e a receita mostra quanto repassar a cada organizador.
-- Resultado esperado: 4 organizadores; Instituto Saber Tech lidera (R$ 2.025,00 em ingressos e R$ 202,50 de taxa). Rock Paraná Produções não aparece, pois não tem eventos.
SELECT
    vr.id_organizador,
    vr.nome_organizador,
    o.email AS email_organizador,
    o.cnpj_cpf,
    vr.total_ingressos_vendidos,
    vr.receita_total_ingressos,
    vr.taxa_plataforma
FROM vw_receita_por_organizador vr
INNER JOIN organizadores o
    ON o.id_organizador = vr.id_organizador
ORDER BY
    vr.receita_total_ingressos DESC;

-- Pergunta 2: Quais eventos venderam mais de 70% de sua capacidade total de ingressos, ordenados pela maior taxa de ocupação?
-- Por que importa: Mostra os eventos com alta procura, candidatos a novos lotes, novas edições ou locais maiores.
-- Resultado esperado: 2 eventos: Workshop SQL na Prática (87,50%) e Workshop de Fotografia com Celular (80,00%).
SELECT
    e.id_evento,
    e.nome AS nome_evento,
    o.nome AS nome_organizador,
    e.capacidade AS capacidade_evento,
    COUNT(i.id_ingresso) AS total_ingressos_vendidos,
    ROUND((COUNT(i.id_ingresso) * 100.0 / e.capacidade), 2) AS taxa_ocupacao_pct
FROM eventos e
INNER JOIN organizadores o
    ON o.id_organizador = e.id_organizador
INNER JOIN lotes l
    ON l.id_evento = e.id_evento
INNER JOIN ingressos i
    ON i.id_lote = l.id_lote
INNER JOIN compras c
    ON c.id_compra = i.id_compra
WHERE c.situacao = 'paga'
  AND i.status_ingresso = 'ativo'
GROUP BY
    e.id_evento,
    e.nome,
    o.nome,
    e.capacidade
HAVING
    (COUNT(i.id_ingresso) * 100.0 / e.capacidade) > 70.0
ORDER BY
    taxa_ocupacao_pct DESC;

-- Pergunta 3: Qual é a taxa de presença (porcentagem de check-ins realizados em relação aos ingressos vendidos) para cada evento?
-- Por que importa: Mede quantos compradores realmente comparecem, o que ajuda a dimensionar equipe e estrutura nos próximos eventos.
-- Resultado esperado: 5 eventos; Festival Noites de Verão e Workshop de Fotografia com 75,00%. A Feira Gastronômica aparece com 0,00%, pois ainda não aconteceu.
SELECT
    e.id_evento,
    e.nome AS nome_evento,
    e.categoria,
    COUNT(DISTINCT i.id_ingresso) AS ingressos_vendidos,
    COUNT(DISTINCT ch.id_ingresso) AS participantes_presentes,
    ROUND((COUNT(DISTINCT ch.id_ingresso) * 100.0 / COUNT(DISTINCT i.id_ingresso)), 2) AS taxa_comparecimento_pct
FROM eventos e
INNER JOIN lotes l
    ON l.id_evento = e.id_evento
INNER JOIN ingressos i
    ON i.id_lote = l.id_lote
INNER JOIN compras c
    ON c.id_compra = i.id_compra
LEFT JOIN checkins ch
    ON ch.id_ingresso = i.id_ingresso
WHERE c.situacao = 'paga'
  AND i.status_ingresso = 'ativo'
GROUP BY
    e.id_evento,
    e.nome,
    e.categoria
ORDER BY
    taxa_comparecimento_pct DESC,
    ingressos_vendidos DESC;

-- Pergunta 4: Quais as 5 atrações com maior nota média, considerando apenas as que participaram de mais de 1 evento? (A maior quantidade de avaliações é o critério de desempate).
-- Por que importa: Ajuda a escolher atrações bem avaliadas e já testadas em mais de um evento para as próximas programações.
-- Resultado esperado: 3 atrações: Prof. Ricardo Tanaka (4,40), Marcos Vieira (4,29) e Trio Serra Acima (4,25). Chef Paula Andrade não entra porque ainda não tem avaliações.
SELECT
    a.id_atracao,
    a.nome_atracao,
    a.tipo_atracao,
    COUNT(DISTINCT ea.id_evento) AS total_eventos_participados,
    COUNT(av.id_avaliacao) AS total_avaliacoes,
    ROUND(AVG(av.nota), 2) AS nota_media
FROM atracoes a
INNER JOIN evento_atracoes ea
    ON ea.id_atracao = a.id_atracao
LEFT JOIN lotes l
    ON l.id_evento = ea.id_evento
LEFT JOIN ingressos i
    ON i.id_lote = l.id_lote
LEFT JOIN avaliacoes av
    ON av.id_ingresso = i.id_ingresso
GROUP BY
    a.id_atracao,
    a.nome_atracao,
    a.tipo_atracao
HAVING
    COUNT(DISTINCT ea.id_evento) > 1
    AND COUNT(av.id_avaliacao) > 0
ORDER BY
    nota_media DESC,
    total_avaliacoes DESC
LIMIT 5;

-- Pergunta 5: Qual é o total financeiro e a quantidade de ingressos vendidos por categoria de evento e tipo de ingresso, detalhando a descrição de cada tipo?
-- Por que importa: Mostra quais combinações de categoria e tipo de ingresso geram mais receita, orientando preços e lotes.
-- Resultado esperado: 8 combinações; Workshop / Inteira tem a maior quantidade (15 ingressos, R$ 1.560,00).
SELECT
    vv.categoria_evento,
    vv.tipo_ingresso,
    t.descricao AS descricao_tipo_ingresso,
    vv.quantidade_ingressos_vendidos,
    vv.valor_total_vendido
FROM vw_vendas_categoria_tipo_ingresso vv
INNER JOIN tipos_ingressos t
    ON t.nome_tipo = vv.tipo_ingresso
ORDER BY
    vv.categoria_evento ASC,
    vv.valor_total_vendido DESC;

-- Pergunta 6: Quais usuários compraram ingressos para terceiros (onde o CPF do participante registrado no ingresso é diferente do CPF do comprador) e quantos ingressos cada um comprou nessa condição?
-- Por que importa: Identifica quem compra para grupos, público-alvo para promoções de pacotes e ingressos em grupo.
-- Resultado esperado: 9 usuários; Larissa Gomes e Mariana Costa compraram 4 ingressos para terceiros cada.
SELECT
    u.id_usuario,
    u.nome AS nome_comprador,
    u.email AS email_comprador,
    u.cpf AS cpf_comprador,
    COUNT(i.id_ingresso) AS total_ingressos_terceiros,
    SUM(i.valor_pago) AS valor_total_terceiros
FROM usuarios u
INNER JOIN compras c
    ON c.id_usuario = u.id_usuario
INNER JOIN ingressos i
    ON i.id_compra = c.id_compra
WHERE c.situacao = 'paga'
  AND i.status_ingresso = 'ativo'
  AND i.cpf_participante <> u.cpf
GROUP BY
    u.id_usuario
ORDER BY
    total_ingressos_terceiros DESC,
    valor_total_terceiros DESC;