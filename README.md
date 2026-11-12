# 🎟️ Palco Aberto — Banco de Dados

Projeto de banco de dados (MySQL) para a **Palco Aberto**, uma plataforma que conecta organizadores de eventos ao público e vende ingressos para shows, congressos, workshops e feiras.

Trabalho do **Desafio Final de Banco de Dados**, ministrado pelo Prof. MSc. Edgar Cabral, no **Cenário 3 — Plataforma de Eventos**.

## 👥 Equipe

| Integrante |
|---|
| Erick Yuri Maba Silva |
| João Henrique Ramos |
| Joel | 
| Lucas Indalencio Gonçalves de Lima |

## 📌 O problema

A Palco Aberto precisa de um banco de dados para:

- cadastrar eventos, sessões, locais e atrações;
- vender ingressos em lotes e por tipo (Pista, Camarote, VIP, Meia-entrada);
- registrar compras, check-ins, reembolsos e avaliações.

Com esses dados, a empresa quer saber quais eventos vendem mais, a receita por organizador e por categoria, a taxa de comparecimento e quais atrações são mais bem avaliadas.

## 🗂️ Estrutura do repositório

A organização segue a pasta de entrega pedida no enunciado.

```
├── modelo.mwb                     # Modelo EER (MySQL Workbench)
├── der.png                        # DER exportado do Workbench        (pendente)
├── 01_ddl.sql                     # Criação do banco, tabelas, triggers e views
├── 02_dml.sql                     # População do banco
├── 03_consultas_validacao.sql     # Mínimo de 8 consultas             (pendente)
├── 04_consultas_avancadas.sql     # Mínimo de 5 perguntas do cliente  (pendente)
├── relatorio.pdf                  # Relatório de 3 a 5 páginas        (pendente)
└── docs/
    ├── enunciado.pdf              # Enunciado do desafio
    └── etapa1_analise.docx        # Etapa 1: entidades, atributos, relacionamentos e regras
```

## ✅ Andamento

- [x] **1. Análise:** entidades, atributos, relacionamentos e regras (`docs/etapa1_analise.docx`).
- [x] **2. Modelagem:** modelo no Workbench (`modelo.mwb`).
- [ ] **2. Modelagem:** exportar o DER atualizado (`der.png`).
- [x] **3. Criação:** tabelas, restrições e triggers (`01_ddl.sql`).
- [ ] **3. Criação:** 2 views (perguntas 1 e 5).
- [x] **4. População:** `02_dml.sql`, com 167 registros.
- [ ] **5. Consultas de validação:** `03_consultas_validacao.sql`.
- [ ] **6. Consultas avançadas:** `04_consultas_avancadas.sql`.
- [ ] **7. Relatório:** `relatorio.pdf`.
- [ ] **8. Pitch:** apresentação de 10 minutos.

## ▶️ Como executar

Requer **MySQL 8.0.16 ou mais recente**; versões anteriores ignoram as restrições `CHECK`.

Rodar sempre a partir de um banco limpo:

```sql
DROP DATABASE IF EXISTS db_eventos_plataforma;
SOURCE 01_ddl.sql;
SOURCE 02_dml.sql;
SOURCE 03_consultas_validacao.sql;
SOURCE 04_consultas_avancadas.sql;
```

No Workbench, também dá para abrir cada arquivo e executar com ⚡ (Ctrl+Shift+Enter).

## 🧩 Modelo em resumo

São 14 tabelas:

- `usuarios`, `organizadores`, `locais`, `eventos`, `sessoes`, `atracoes`;
- `evento_atracoes` (N:N, com o cachê de cada participação);
- `tipos_ingressos`, `lotes`, `compras`, `ingressos`;
- `checkins`, `reembolsos`, `avaliacoes`.

As regras que envolvem mais de uma tabela são garantidas por triggers:

- a capacidade do evento não passa a do local;
- não é possível vender ingresso de um lote esgotado nem acima da capacidade do evento;
- o check-in só vale em sessão do evento do ingresso;
- só avalia quem fez check-in.

A taxa da plataforma (10%) e o total de cada compra não ficam gravados na tabela. Eles são calculados a partir do `valor_pago` de cada ingresso.

## 🤝 Combinados da equipe

- **Arquivos `.sql`:** podem ser editados em paralelo, porque o GitHub mostra as diferenças linha a linha.
- **`modelo.mwb` e `.docx`:** só uma pessoa edita por vez. Avise no grupo antes de começar e envie logo ao terminar.
- **Mensagens de commit:** devem dizer o que mudou, por exemplo `Adiciona view de receita por organizador`.
- **Antes de entregar:** testar tudo do zero (DROP → DDL → DML → consultas).
