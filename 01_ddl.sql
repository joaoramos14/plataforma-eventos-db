-- Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS db_eventos_plataforma;
USE db_eventos_plataforma;

-- 1. Tabela de Usuários (Compradores e Participantes)
CREATE TABLE usuarios (
    id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    data_cadastro DATETIME NOT NULL
);

-- 2. Tabela de Organizadores
CREATE TABLE organizadores (
    id_organizador INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    cnpj_cpf VARCHAR(20) NOT NULL UNIQUE
);

-- 3. Tabela de Locais
CREATE TABLE locais (
    id_local INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_local VARCHAR(150) NOT NULL,
    endereco TEXT NOT NULL,
    capacidade_maxima INT UNSIGNED NOT NULL CHECK (capacidade_maxima > 0)
);

-- 4. Tabela de Tipos de Ingressos (Pista, VIP, etc.)
CREATE TABLE tipos_ingressos (
    id_tipo_ingresso INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(50) NOT NULL,
    descricao TEXT NULL
);

-- 5. Tabela de Atrações (Bandas, Palestrantes, etc.)
CREATE TABLE atracoes (
    id_atracao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_atracao VARCHAR(100) NOT NULL,
    tipo_atracao VARCHAR(50) NOT NULL
);

-- 6. Tabela de Eventos
CREATE TABLE eventos (
    id_evento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_organizador INT UNSIGNED NOT NULL,
    id_local INT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    descricao TEXT NULL,
    capacidade INT UNSIGNED NOT NULL CHECK (capacidade > 0), -- não pode exceder a capacidade do local (validado pela aplicação)
    status VARCHAR(20) NOT NULL DEFAULT 'ativo' CHECK (status IN ('ativo', 'cancelado', 'encerrado')),
    CONSTRAINT fk_evento_organizador FOREIGN KEY (id_organizador) REFERENCES organizadores(id_organizador),
    CONSTRAINT fk_evento_local FOREIGN KEY (id_local) REFERENCES locais(id_local)
);

-- 7. Tabela Associativa: Eventos e Atrações (Relação N:N com atributo cachê)
CREATE TABLE evento_atracoes (
    id_evento INT UNSIGNED NOT NULL,
    id_atracao INT UNSIGNED NOT NULL,
    cache_combinado DECIMAL(10, 2) NOT NULL CHECK (cache_combinado >= 0),
    PRIMARY KEY (id_evento, id_atracao),
    CONSTRAINT fk_evat_evento FOREIGN KEY (id_evento) REFERENCES eventos(id_evento),
    CONSTRAINT fk_evat_atracao FOREIGN KEY (id_atracao) REFERENCES atracoes(id_atracao)
);

-- 8. Tabela de Sessões do Evento (Ex: Dias do Congresso)
CREATE TABLE sessoes (
    id_sessao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_evento INT UNSIGNED NOT NULL,
    nome_sessao VARCHAR(100) NOT NULL,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NOT NULL,
    CONSTRAINT ck_sessao_periodo CHECK (data_hora_fim > data_hora_inicio),
    CONSTRAINT fk_sessao_evento FOREIGN KEY (id_evento) REFERENCES eventos(id_evento)
);

-- 9. Tabela de Lotes de Ingressos
CREATE TABLE lotes (
    id_lote INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_evento INT UNSIGNED NOT NULL,
    id_tipo_ingresso INT UNSIGNED NOT NULL,
    numero_lote INT UNSIGNED NOT NULL CHECK (numero_lote >= 1),
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    quantidade_total INT UNSIGNED NOT NULL CHECK (quantidade_total > 0),
    CONSTRAINT uq_lote_evento_tipo_numero UNIQUE (id_evento, id_tipo_ingresso, numero_lote),
    CONSTRAINT fk_lote_evento FOREIGN KEY (id_evento) REFERENCES eventos(id_evento),
    CONSTRAINT fk_lote_tipo FOREIGN KEY (id_tipo_ingresso) REFERENCES tipos_ingressos(id_tipo_ingresso)
);

-- 10. Tabela de Compras (Transações Financeiras)
-- Valor total e taxa da plataforma (10%) não são armazenados: são calculados
-- a partir dos ingressos (evita dado derivado e mantém a 3FN).
CREATE TABLE compras (
    id_compra INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    data_compra DATETIME NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL CHECK (forma_pagamento IN ('cartao', 'pix', 'boleto')),
    situacao VARCHAR(30) NOT NULL CHECK (situacao IN ('paga', 'pendente', 'cancelada')),
    CONSTRAINT fk_compra_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- 11. Tabela de Ingressos (Gerados por lote/compra)
-- O evento do ingresso é obtido pelo lote (ingresso -> lote -> evento).
CREATE TABLE ingressos (
    id_ingresso INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_compra INT UNSIGNED NOT NULL,
    id_lote INT UNSIGNED NOT NULL,
    nome_participante VARCHAR(100) NOT NULL,
    cpf_participante VARCHAR(14) NOT NULL, -- identifica quem vai ao evento (pode não ser o comprador)
    valor_pago DECIMAL(10, 2) NOT NULL CHECK (valor_pago >= 0), -- preço do lote no momento da compra
    status_ingresso VARCHAR(30) NOT NULL DEFAULT 'ativo' CHECK (status_ingresso IN ('ativo', 'cancelado')),
    CONSTRAINT fk_ingresso_compra FOREIGN KEY (id_compra) REFERENCES compras(id_compra),
    CONSTRAINT fk_ingresso_lote FOREIGN KEY (id_lote) REFERENCES lotes(id_lote)
);

-- 12. Tabela de Check-ins (Vinculado por ingresso e sessão específica)
CREATE TABLE checkins (
    id_checkin INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ingresso INT UNSIGNED NOT NULL,
    id_sessao INT UNSIGNED NOT NULL,
    data_hora_checkin DATETIME NOT NULL,
    CONSTRAINT uq_checkin_ingresso_sessao UNIQUE (id_ingresso, id_sessao),
    CONSTRAINT fk_checkin_ingresso FOREIGN KEY (id_ingresso) REFERENCES ingressos(id_ingresso),
    CONSTRAINT fk_checkin_sessao FOREIGN KEY (id_sessao) REFERENCES sessoes(id_sessao)
);

-- 13. Tabela de Reembolsos (Vinculado à compra, no máximo 1 por compra)
CREATE TABLE reembolsos (
    id_reembolso INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_compra INT UNSIGNED NOT NULL UNIQUE,
    data_reembolso DATETIME NOT NULL,
    valor_reembolso DECIMAL(10, 2) NOT NULL CHECK (valor_reembolso > 0),
    motivo TEXT NOT NULL,
    CONSTRAINT fk_reembolso_compra FOREIGN KEY (id_compra) REFERENCES compras(id_compra)
);

-- 14. Tabela de Avaliações (De quem participou / fez check-in, no máximo 1 por ingresso)
-- O evento avaliado é obtido pelo ingresso (ingresso -> lote -> evento).
CREATE TABLE avaliacoes (
    id_avaliacao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_ingresso INT UNSIGNED NOT NULL UNIQUE,
    nota INT UNSIGNED NOT NULL CHECK (nota BETWEEN 1 AND 5), -- 1 a 5
    comentario TEXT NULL,
    data_avaliacao DATETIME NOT NULL,
    CONSTRAINT fk_avaliacao_ingresso FOREIGN KEY (id_ingresso) REFERENCES ingressos(id_ingresso)
);

