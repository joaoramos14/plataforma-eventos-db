-- População do Banco de Dados
-- Executar após o 01_ddl.sql, em um banco recém-criado.
USE db_eventos_plataforma;

-- 1. Usuários (os dois últimos ainda não fizeram compras)
INSERT INTO usuarios (id_usuario, nome, email, cpf, telefone, data_cadastro) VALUES
(1, 'Mariana Costa', 'mariana.costa@gmail.com', '321.654.987-10', '(41) 99812-3456', '2025-03-14 10:22:00'),
(2, 'Pedro Henrique Alves', 'pedro.alves@hotmail.com', '458.123.769-04', '(41) 98744-1290', '2025-05-02 18:40:00'),
(3, 'Juliana Ferreira', 'ju.ferreira@gmail.com', '159.753.486-22', '(41) 99631-7788', '2025-06-21 09:15:00'),
(4, 'Rafael Souza', 'rafael.souza@outlook.com', '852.369.741-08', '(41) 99205-4411', '2025-08-11 14:03:00'),
(5, 'Camila Ribeiro', 'camila.ribeiro@empresa.com.br', '741.258.963-50', '(41) 98877-6655', '2025-09-30 11:47:00'),
(6, 'Lucas Martins', 'lucas.martins@gmail.com', '963.852.147-36', '(41) 99102-3344', '2025-11-18 20:12:00'),
(7, 'Beatriz Lima', 'bia.lima@gmail.com', '357.159.258-91', '(41) 99456-1020', '2026-01-09 16:30:00'),
(8, 'Gustavo Pereira', 'gustavo.pereira@yahoo.com.br', '246.813.579-63', NULL, '2026-02-23 08:55:00'),
(9, 'Larissa Gomes', 'larissa.gomes@gmail.com', '135.792.468-27', '(41) 98321-9090', '2026-03-17 13:20:00'),
(10, 'Thiago Carvalho', 'thiago.carvalho@gmail.com', '864.209.753-18', '(41) 99777-2468', '2026-04-05 19:05:00'),
(11, 'Fernanda Rocha', 'fernanda.rocha@outlook.com', '579.135.246-80', '(41) 99540-8642', '2026-05-28 10:10:00'),
(12, 'Bruno Oliveira', 'bruno.oliveira@gmail.com', '680.246.135-79', '(41) 98612-7531', '2026-07-01 21:48:00'),
(13, 'Aline Barbosa', 'aline.barbosa@gmail.com', '702.468.913-55', '(41) 99333-1357', '2026-09-14 15:25:00'),
(14, 'Diego Nunes', 'diego.nunes@hotmail.com', '913.570.246-41', NULL, '2026-10-30 12:00:00');

-- 2. Organizadores (o último ainda não cadastrou eventos)
INSERT INTO organizadores (id_organizador, nome, email, telefone, cnpj_cpf) VALUES
(1, 'Sons do Sul Produções', 'contato@sonsdosul.com.br', '(41) 3322-1100', '12.345.678/0001-90'),
(2, 'Instituto Saber Tech', 'eventos@sabertech.org.br', '(41) 3015-4400', '23.456.789/0001-01'),
(3, 'Feira Viva Eventos', 'comercial@feiraviva.com.br', '(41) 3254-8800', '34.567.890/0001-12'),
(4, 'Ana Paula Mendes', 'anapaula.cursos@gmail.com', '(41) 99870-5544', '427.913.586-03'),
(5, 'Rock Paraná Produções', 'producao@rockparana.com.br', NULL, '45.678.901/0001-23');

-- 3. Locais
INSERT INTO locais (id_local, nome_local, endereco, capacidade_maxima) VALUES
(1, 'Arena Curitiba Hall', 'Av. Sete de Setembro, 4500 - Batel, Curitiba - PR', 3000),
(2, 'Centro de Convenções Paraná', 'Rua Marechal Deodoro, 1200 - Centro, Curitiba - PR', 800),
(3, 'Espaço Cultural Largo da Ordem', 'Largo da Ordem, 45 - São Francisco, Curitiba - PR', 200),
(4, 'Pavilhão Barigui Expo', 'Av. Cândido Hartmann, 2000 - Bigorrilho, Curitiba - PR', 1500),
(5, 'Hub Batel Coworking', 'Rua Bispo Dom José, 300 - Batel, Curitiba - PR', 40);

-- 4. Tipos de Ingressos
INSERT INTO tipos_ingressos (id_tipo_ingresso, nome_tipo, descricao) VALUES
(1, 'Pista', 'Acesso à área de pista, em pé.'),
(2, 'Camarote', 'Área reservada com open bar e vista privilegiada do palco.'),
(3, 'VIP', 'Acesso antecipado, área exclusiva e brinde do evento.'),
(4, 'Meia-entrada', 'Estudantes, idosos e PCD, com apresentação de documento na entrada.'),
(5, 'Inteira', 'Ingresso padrão para congressos, workshops e feiras.');

-- 5. Atrações
INSERT INTO atracoes (id_atracao, nome_atracao, tipo_atracao) VALUES
(1, 'Banda Maré Alta', 'Banda'),
(2, 'Trio Serra Acima', 'Banda'),
(3, 'DJ Kaio Lopes', 'DJ'),
(4, 'Dra. Helena Prado', 'Palestrante'),
(5, 'Prof. Ricardo Tanaka', 'Palestrante'),
(6, 'Marcos Vieira', 'Mestre de cerimônias'),
(7, 'Coral Vozes de Curitiba', 'Coral'),
(8, 'Chef Paula Andrade', 'Palestrante'),
(9, 'Léo Brandão', 'Humorista');

-- 6. Eventos
-- encerrado: já aconteceu | ativo: vendas abertas | cancelado: cancelado pelo organizador
-- O evento 7 está à venda, mas ainda não teve nenhuma venda.
INSERT INTO eventos (id_evento, id_organizador, id_local, nome, categoria, descricao, capacidade, status) VALUES
(1, 1, 1, 'Festival Noites de Verão', 'Show', 'Dois dias de música ao vivo com bandas da cena paranaense.', 2500, 'encerrado'),
(2, 2, 2, 'Congresso de Tecnologia e Dados 2026', 'Congresso', 'Três dias de palestras sobre dados, nuvem e inteligência artificial.', 600, 'encerrado'),
(3, 4, 5, 'Workshop SQL na Prática', 'Workshop', 'Turma reduzida, com exercícios em MySQL do básico ao avançado.', 8, 'encerrado'),
(4, 3, 4, 'Feira Gastronômica Sabores do Paraná', 'Feira', 'Produtores locais, food trucks e aulas-show de culinária.', 1200, 'ativo'),
(5, 4, 5, 'Workshop de Fotografia com Celular', 'Workshop', 'Técnicas de composição e edição usando apenas o celular.', 10, 'encerrado'),
(6, 1, 3, 'Noite de Stand-up', 'Show', 'Apresentação de comédia stand-up.', 180, 'cancelado'),
(7, 3, 2, 'Congresso Paranaense de Gastronomia', 'Congresso', 'Tendências do setor de alimentação, com chefs convidados.', 500, 'ativo');

-- 7. Participação das Atrações nos Eventos (com cachê)
INSERT INTO evento_atracoes (id_evento, id_atracao, cache_combinado) VALUES
(1, 1, 15000.00),
(1, 2, 8000.00),
(1, 3, 5000.00),
(1, 6, 1500.00),
(2, 4, 6000.00),
(2, 5, 4500.00),
(2, 6, 2500.00),
(3, 5, 1200.00),
(4, 8, 3000.00),
(4, 2, 4000.00),
(4, 7, 2000.00),
(6, 9, 3500.00),
(7, 8, 5000.00),
(7, 6, 2000.00);

-- 8. Sessões
INSERT INTO sessoes (id_sessao, id_evento, nome_sessao, data_hora_inicio, data_hora_fim) VALUES
(1, 1, 'Dia 1 - Sábado', '2026-09-12 16:00:00', '2026-09-12 23:30:00'),
(2, 1, 'Dia 2 - Domingo', '2026-09-13 15:00:00', '2026-09-13 22:00:00'),
(3, 2, 'Dia 1 - Dados e Nuvem', '2026-10-06 08:00:00', '2026-10-06 18:00:00'),
(4, 2, 'Dia 2 - Inteligência Artificial', '2026-10-07 08:00:00', '2026-10-07 18:00:00'),
(5, 2, 'Dia 3 - Carreira e Mercado', '2026-10-08 08:00:00', '2026-10-08 13:00:00'),
(6, 3, 'Turma única', '2026-10-17 09:00:00', '2026-10-17 17:00:00'),
(7, 4, 'Sábado', '2026-12-05 10:00:00', '2026-12-05 22:00:00'),
(8, 4, 'Domingo', '2026-12-06 10:00:00', '2026-12-06 20:00:00'),
(9, 5, 'Turma única', '2026-08-22 14:00:00', '2026-08-22 18:00:00'),
(10, 6, 'Sessão única', '2026-11-20 21:00:00', '2026-11-20 23:00:00'),
(11, 7, 'Dia 1', '2027-01-20 08:30:00', '2027-01-20 18:00:00'),
(12, 7, 'Dia 2', '2027-01-21 08:30:00', '2027-01-21 17:00:00');

-- 9. Lotes
INSERT INTO lotes (id_lote, id_evento, id_tipo_ingresso, numero_lote, preco, quantidade_total) VALUES
(1, 1, 1, 1, 80.00, 1000),
(2, 1, 1, 2, 110.00, 1000),
(3, 1, 2, 1, 250.00, 300),
(4, 1, 4, 1, 40.00, 200),
(5, 2, 5, 1, 350.00, 300),
(6, 2, 5, 2, 450.00, 200),
(7, 2, 4, 1, 175.00, 100),
(8, 3, 5, 1, 120.00, 8),
(9, 4, 5, 1, 30.00, 1000),
(10, 4, 3, 1, 90.00, 200),
(11, 5, 5, 1, 90.00, 10),
(12, 6, 1, 1, 60.00, 180),
(13, 7, 5, 1, 280.00, 400),
(14, 7, 3, 1, 600.00, 100);

-- 10. Compras
-- 11: cancelada pelo cliente em até 7 dias | 12: cancelada porque o evento foi cancelado | 14: pendente
INSERT INTO compras (id_compra, id_usuario, data_compra, forma_pagamento, situacao) VALUES
(1, 1, '2026-07-10 20:15:00', 'cartao', 'paga'),
(2, 2, '2026-07-15 12:40:00', 'pix', 'paga'),
(3, 3, '2026-08-20 09:05:00', 'pix', 'paga'),
(4, 4, '2026-08-01 17:30:00', 'boleto', 'paga'),
(5, 5, '2026-08-05 10:00:00', 'cartao', 'paga'),
(6, 6, '2026-09-12 22:18:00', 'pix', 'paga'),
(7, 7, '2026-09-20 14:45:00', 'cartao', 'paga'),
(8, 8, '2026-09-22 08:12:00', 'pix', 'paga'),
(9, 9, '2026-07-25 19:50:00', 'cartao', 'paga'),
(10, 10, '2026-07-28 21:33:00', 'pix', 'paga'),
(11, 11, '2026-10-25 11:20:00', 'pix', 'cancelada'),
(12, 12, '2026-10-15 16:05:00', 'cartao', 'cancelada'),
(13, 1, '2026-11-05 18:00:00', 'cartao', 'paga'),
(14, 2, '2026-11-10 09:30:00', 'boleto', 'pendente'),
(15, 10, '2026-11-08 13:10:00', 'pix', 'paga');

-- 11. Ingressos
-- Quando o participante é o próprio comprador, o CPF é o mesmo do usuário.
-- Ingressos das compras canceladas ficam com status 'cancelado'.
INSERT INTO ingressos (id_ingresso, id_compra, id_lote, nome_participante, cpf_participante, valor_pago, status_ingresso) VALUES
(1, 1, 1, 'Mariana Costa', '321.654.987-10', 80.00, 'ativo'),
(2, 1, 1, 'Ana Clara Souza', '118.227.336-45', 80.00, 'ativo'),
(3, 1, 1, 'Felipe Ramos', '229.338.447-56', 80.00, 'ativo'),
(4, 1, 1, 'Isabela Torres', '330.449.558-67', 80.00, 'ativo'),
(5, 2, 3, 'Pedro Henrique Alves', '458.123.769-04', 250.00, 'ativo'),
(6, 2, 3, 'Carla Mendes', '441.550.669-78', 250.00, 'ativo'),
(7, 3, 2, 'Juliana Ferreira', '159.753.486-22', 110.00, 'ativo'),
(8, 3, 4, 'Sofia Ferreira', '552.661.770-89', 40.00, 'ativo'),
(9, 4, 5, 'Rafael Souza', '852.369.741-08', 350.00, 'ativo'),
(10, 5, 5, 'Camila Ribeiro', '741.258.963-50', 350.00, 'ativo'),
(11, 5, 5, 'Otávio Lins', '663.772.881-90', 350.00, 'ativo'),
(12, 5, 5, 'Patrícia Moura', '774.883.992-01', 350.00, 'ativo'),
(13, 6, 6, 'Lucas Martins', '963.852.147-36', 450.00, 'ativo'),
(14, 6, 7, 'Vinícius Prado', '885.994.003-12', 175.00, 'ativo'),
(15, 7, 8, 'Beatriz Lima', '357.159.258-91', 120.00, 'ativo'),
(16, 7, 8, 'Gabriel Teixeira', '996.005.114-23', 120.00, 'ativo'),
(17, 7, 8, 'Renata Duarte', '107.216.325-34', 120.00, 'ativo'),
(18, 7, 8, 'Caio Fernandes', '218.327.436-45', 120.00, 'ativo'),
(19, 8, 8, 'Gustavo Pereira', '246.813.579-63', 120.00, 'ativo'),
(20, 8, 8, 'Helena Castro', '329.438.547-56', 120.00, 'ativo'),
(21, 8, 8, 'Murilo Antunes', '431.540.659-67', 120.00, 'ativo'),
(22, 9, 11, 'Larissa Gomes', '135.792.468-27', 90.00, 'ativo'),
(23, 9, 11, 'Marina Lopes', '542.651.760-78', 90.00, 'ativo'),
(24, 9, 11, 'Rodrigo Pires', '653.762.871-89', 90.00, 'ativo'),
(25, 9, 11, 'Tatiane Reis', '764.873.982-90', 90.00, 'ativo'),
(26, 9, 11, 'Eduardo Viana', '875.984.093-01', 90.00, 'ativo'),
(27, 10, 11, 'Thiago Carvalho', '864.209.753-18', 90.00, 'ativo'),
(28, 10, 11, 'Natália Cruz', '986.095.104-12', 90.00, 'ativo'),
(29, 10, 11, 'Paulo Freitas', '097.106.215-23', 90.00, 'ativo'),
(30, 11, 10, 'Fernanda Rocha', '579.135.246-80', 90.00, 'cancelado'),
(31, 11, 10, 'Júlia Rocha', '108.217.326-34', 90.00, 'cancelado'),
(32, 12, 12, 'Bruno Oliveira', '680.246.135-79', 60.00, 'cancelado'),
(33, 12, 12, 'Letícia Campos', '219.328.437-45', 60.00, 'cancelado'),
(34, 13, 9, 'Mariana Costa', '321.654.987-10', 30.00, 'ativo'),
(35, 13, 9, 'Ana Clara Souza', '118.227.336-45', 30.00, 'ativo'),
(36, 14, 9, 'Pedro Henrique Alves', '458.123.769-04', 30.00, 'ativo'),
(37, 14, 9, 'Carla Mendes', '441.550.669-78', 30.00, 'ativo'),
(38, 14, 9, 'Roberto Alves', '320.439.548-56', 30.00, 'ativo'),
(39, 15, 10, 'Thiago Carvalho', '864.209.753-18', 90.00, 'ativo');

-- 12. Check-ins (apenas eventos já realizados; alguns participantes faltaram)
INSERT INTO checkins (id_checkin, id_ingresso, id_sessao, data_hora_checkin) VALUES
(1, 1, 1, '2026-09-12 16:42:00'),
(2, 1, 2, '2026-09-13 15:20:00'),
(3, 2, 1, '2026-09-12 16:43:00'),
(4, 3, 1, '2026-09-12 17:05:00'),
(5, 5, 1, '2026-09-12 18:30:00'),
(6, 6, 2, '2026-09-13 16:10:00'),
(7, 7, 2, '2026-09-13 15:55:00'),
(8, 9, 3, '2026-10-06 07:48:00'),
(9, 9, 4, '2026-10-07 07:55:00'),
(10, 9, 5, '2026-10-08 08:02:00'),
(11, 10, 3, '2026-10-06 08:10:00'),
(12, 11, 3, '2026-10-06 08:11:00'),
(13, 11, 4, '2026-10-07 08:30:00'),
(14, 13, 3, '2026-10-06 09:15:00'),
(15, 15, 6, '2026-10-17 08:50:00'),
(16, 16, 6, '2026-10-17 08:52:00'),
(17, 17, 6, '2026-10-17 08:58:00'),
(18, 19, 6, '2026-10-17 09:03:00'),
(19, 20, 6, '2026-10-17 09:04:00'),
(20, 22, 9, '2026-08-22 13:45:00'),
(21, 23, 9, '2026-08-22 13:47:00'),
(22, 24, 9, '2026-08-22 13:58:00'),
(23, 25, 9, '2026-08-22 14:05:00'),
(24, 27, 9, '2026-08-22 13:50:00'),
(25, 28, 9, '2026-08-22 13:51:00');

-- 13. Reembolsos
INSERT INTO reembolsos (id_reembolso, id_compra, data_reembolso, valor_reembolso, motivo) VALUES
(1, 11, '2026-10-28 10:00:00', 180.00, 'Desistência do cliente dentro do prazo de 7 dias.'),
(2, 12, '2026-11-11 15:30:00', 120.00, 'Evento cancelado pelo organizador.');

-- 14. Avaliações (somente ingressos com check-in)
INSERT INTO avaliacoes (id_avaliacao, id_ingresso, nota, comentario, data_avaliacao) VALUES
(1, 1, 5, 'Show impecável, som excelente nos dois dias.', '2026-09-14 10:12:00'),
(2, 2, 4, 'Muito bom, mas a fila do bar estava grande.', '2026-09-14 11:40:00'),
(3, 5, 5, 'O camarote valeu cada centavo.', '2026-09-15 09:05:00'),
(4, 7, 3, 'Gostei das bandas, mas a entrada foi demorada.', '2026-09-14 20:30:00'),
(5, 9, 5, 'Palestras de alto nível nos três dias.', '2026-10-09 18:22:00'),
(6, 10, 4, 'Conteúdo ótimo, intervalos curtos demais.', '2026-10-09 12:10:00'),
(7, 13, 4, NULL, '2026-10-10 08:45:00'),
(8, 15, 5, 'Aprendi muito, a turma pequena ajudou.', '2026-10-18 19:00:00'),
(9, 19, 4, 'Bom ritmo, poderia ter mais exercícios.', '2026-10-19 07:30:00'),
(10, 22, 2, 'Esperava mais conteúdo prático.', '2026-08-23 10:15:00'),
(11, 27, 3, NULL, '2026-08-24 21:00:00');
