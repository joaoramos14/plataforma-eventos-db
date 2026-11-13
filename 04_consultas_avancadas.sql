-- Consultas avançadas
-- Responder perguntas de negócio com SQL mais elaborado

USE db_eventos_plataforma;

-- View 1: Consolida a receita bruta dos ingressos ativos de compras pagas e calcula a taxa de 10% da plataforma por organizado
CREATE VIEW vw_receita_por_organizador AS
SELECT 
    organizadores.id_organizador, 
    organizadores.nome AS nome_organizador, 
    COUNT(ingressos.id_ingresso) AS total_ingressos_vendidos, 
    SUM(ingressos.valor_pago) AS receita_total_ingressos, 
    ROUND(SUM(ingressos.valor_pago) * 0.10, 2) AS taxa_plataforma 
FROM organizadores 
INNER JOIN eventos 
    ON eventos.id_organizador = organizadores.id_organizador 
INNER JOIN lotes 
    ON lotes.id_evento = eventos.id_evento 
INNER JOIN ingressos 
    ON ingressos.id_lote = lotes.id_lote 
INNER JOIN compras 
    ON compras.id_compra = ingressos.id_compra 
WHERE compras.situacao = 'paga' 
  AND ingressos.status_ingresso = 'ativo' 
GROUP BY 
    organizadores.id_organizador, 
    organizadores.nome;
    
    
-- View 2: Consolida a quantidade de ingressos vendidos e o valor arrecadado agrupado por categoria do evento e tipo de ingresso
CREATE VIEW vw_vendas_categoria_tipo_ingresso AS
SELECT 
    eventos.categoria AS categoria_evento, 
    tipos_ingressos.nome_tipo AS tipo_ingresso, 
    COUNT(ingressos.id_ingresso) AS quantidade_ingressos_vendidos, 
    SUM(ingressos.valor_pago) AS valor_total_vendido 
FROM eventos 
INNER JOIN lotes 
    ON lotes.id_evento = eventos.id_evento 
INNER JOIN tipos_ingressos 
    ON tipos_ingressos.id_tipo_ingresso = lotes.id_tipo_ingresso 
INNER JOIN ingressos 
    ON ingressos.id_lote = lotes.id_lote 
INNER JOIN compras 
    ON compras.id_compra = ingressos.id_compra 
WHERE compras.situacao = 'paga' 
  AND ingressos.status_ingresso = 'ativo' 
GROUP BY 
    eventos.categoria, 
    tipos_ingressos.nome_tipo;
    
-- Pergunta 1: Qual a receita total de ingressos e a receita gerada pela taxa da plataforma (10%) por organizador, incluindo seus dados de contato?
SELECT 
    vw_receita_por_organizador.id_organizador, 
    vw_receita_por_organizador.nome_organizador, 
    organizadores.email AS email_organizador, 
    organizadores.cnpj_cpf, 
    vw_receita_por_organizador.total_ingressos_vendidos, 
    vw_receita_por_organizador.receita_total_ingressos, 
    vw_receita_por_organizador.taxa_plataforma 
FROM vw_receita_por_organizador 
INNER JOIN organizadores 
    ON organizadores.id_organizador = vw_receita_por_organizador.id_organizador 
ORDER BY 
    vw_receita_por_organizador.receita_total_ingressos DESC;
    
-- Pergunta 2: Quais eventos venderam mais de 70% de sua capacidade total de ingressos, ordenados pela maior taxa de ocupação?
SELECT 
    eventos.id_evento, 
    eventos.nome AS nome_evento, 
    organizadores.nome AS nome_organizador, 
    eventos.capacidade AS capacidade_evento, 
    COUNT(ingressos.id_ingresso) AS total_ingressos_vendidos, 
    ROUND((COUNT(ingressos.id_ingresso) * 100.0 / eventos.capacidade), 2) AS taxa_ocupacao_pct 
FROM eventos 
INNER JOIN organizadores 
    ON organizadores.id_organizador = eventos.id_organizador 
INNER JOIN lotes 
    ON lotes.id_evento = eventos.id_evento 
INNER JOIN ingressos 
    ON ingressos.id_lote = lotes.id_lote 
INNER JOIN compras 
    ON compras.id_compra = ingressos.id_compra 
WHERE compras.situacao = 'paga' 
  AND ingressos.status_ingresso = 'ativo' 
GROUP BY 
    eventos.id_evento, 
    eventos.nome, 
    organizadores.nome, 
    eventos.capacidade 
HAVING 
    (COUNT(ingressos.id_ingresso) * 100.0 / eventos.capacidade) > 70.0 
ORDER BY 
    taxa_ocupacao_pct DESC;
    
-- Pergunta 3: Qual é a taxa de presença (porcentagem de check-ins realizados em relação aos ingressos vendidos) para cada evento?
SELECT 
    eventos.id_evento, 
    eventos.nome AS nome_evento, 
    eventos.categoria, 
    COUNT(DISTINCT ingressos.id_ingresso) AS ingressos_vendidos, 
    COUNT(DISTINCT checkins.id_ingresso) AS participantes_presentes, 
    ROUND((COUNT(DISTINCT checkins.id_ingresso) * 100.0 / COUNT(DISTINCT ingressos.id_ingresso)), 2) AS taxa_comparecimento_pct 
FROM eventos 
INNER JOIN lotes 
    ON lotes.id_evento = eventos.id_evento 
INNER JOIN ingressos 
    ON ingressos.id_lote = lotes.id_lote 
INNER JOIN compras 
    ON compras.id_compra = ingressos.id_compra 
LEFT JOIN checkins 
    ON checkins.id_ingresso = ingressos.id_ingresso 
WHERE compras.situacao = 'paga' 
  AND ingressos.status_ingresso = 'ativo' 
GROUP BY 
    eventos.id_evento, 
    eventos.nome, 
    eventos.categoria 
ORDER BY 
    taxa_comparecimento_pct DESC, 
    ingressos_vendidos DESC;
    
-- Pergunta 4: Qual a atração com melhor nota média de avaliação, considerando apenas aquelas que participaram de mais de 1 evento? (A maior quantidade de avaliações é o critério de desempate).
SELECT 
    atracoes.id_atracao, 
    atracoes.nome_atracao, 
    atracoes.tipo_atracao, 
    COUNT(DISTINCT evento_atracoes.id_evento) AS total_eventos_participados, 
    COUNT(avaliacoes.id_avaliacao) AS total_avaliacoes, 
    ROUND(AVG(avaliacoes.nota), 2) AS nota_media 
FROM atracoes 
INNER JOIN evento_atracoes 
    ON evento_atracoes.id_atracao = atracoes.id_atracao 
INNER JOIN eventos 
    ON eventos.id_evento = evento_atracoes.id_evento 
INNER JOIN lotes 
    ON lotes.id_evento = eventos.id_evento 
INNER JOIN ingressos 
    ON ingressos.id_lote = lotes.id_lote 
INNER JOIN avaliacoes 
    ON avaliacoes.id_ingresso = ingressos.id_ingresso 
GROUP BY 
    atracoes.id_atracao, 
    atracoes.nome_atracao, 
    atracoes.tipo_atracao 
HAVING 
    COUNT(DISTINCT evento_atracoes.id_evento) > 1 
ORDER BY 
    nota_media DESC,
    total_avaliacoes DESC 
LIMIT 1;

-- Pergunta 5: Qual é o total financeiro e a quantidade de ingressos vendidos por categoria de evento e tipo de ingresso, detalhando a descrição de cada tipo?
SELECT 
    vw_vendas_categoria_tipo_ingresso.categoria_evento, 
    vw_vendas_categoria_tipo_ingresso.tipo_ingresso, 
    tipos_ingressos.descricao AS descricao_tipo_ingresso, 
    vw_vendas_categoria_tipo_ingresso.quantidade_ingressos_vendidos, 
    vw_vendas_categoria_tipo_ingresso.valor_total_vendido 
FROM vw_vendas_categoria_tipo_ingresso 
INNER JOIN tipos_ingressos 
    ON tipos_ingressos.nome_tipo = vw_vendas_categoria_tipo_ingresso.tipo_ingresso 
ORDER BY 
    vw_vendas_categoria_tipo_ingresso.categoria_evento ASC, 
    vw_vendas_categoria_tipo_ingresso.valor_total_vendido DESC;
     
-- Pergunta 6: Quais usuários compraram ingressos para terceiros (onde o CPF do participante registrado no ingresso é diferente do CPF do comprador) e quantos ingressos cada um comprou nessa condição?
SELECT 
    usuarios.id_usuario, 
    usuarios.nome AS nome_comprador, 
    usuarios.email AS email_comprador, 
    usuarios.cpf AS cpf_comprador, 
    COUNT(ingressos.id_ingresso) AS total_ingressos_terceiros, 
    SUM(ingressos.valor_pago) AS valor_total_terceiros 
FROM usuarios 
INNER JOIN compras 
    ON compras.id_usuario = usuarios.id_usuario 
INNER JOIN ingressos 
    ON ingressos.id_compra = compras.id_compra 
WHERE compras.situacao = 'paga' 
  AND ingressos.status_ingresso = 'ativo' 
  AND ingressos.cpf_participante <> usuarios.cpf 
GROUP BY 
    usuarios.id_usuario 
ORDER BY 
    total_ingressos_terceiros DESC, 
    valor_total_terceiros DESC;