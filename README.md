# 🎬 CineStream — Projeto de Banco de Dados

Projeto final da disciplina **Banco de Dados I** (2026.1 A) do Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas — **IFPB**.

Professor: André Atanasio Maranhão Almeida                                                         
Equipe: Erick Lucas Da Silva Santos, Maria Isabel Feliciano de Melo, Wesley Trajano Cardoso do Carmo
, 
## 📖 Sobre o projeto

A **CineStream** é uma plataforma fictícia de streaming de vídeo. O sistema modelado gerencia assinantes, planos de serviço, perfis de usuário, catálogo de obras audiovisuais (filmes e séries), profissionais da indústria (atores e diretores), dispositivos, histórico de visualizações e faturamento.

### Minimundo

A plataforma precisa gerenciar assinantes (nome, CPF, e-mail, telefone e status da conta), que contratam planos de serviço (nome, quantidade máxima de telas e qualidade de resolução). Como um assinante pode trocar de plano ao longo do tempo, o sistema mantém um histórico de assinaturas com datas e valores cobrados.

Cada conta pode ter vários perfis (nome de exibição, avatar e classificação etária). O catálogo armazena obras (título, sinopse, ano de lançamento, idade mínima recomendada), relacionadas a um ou mais gêneros e a profissionais (atores/diretores). Obras do tipo série possuem episódios, organizados por temporada.

O sistema também registra as visualizações feitas por cada perfil (data/hora, porcentagem assistida, dispositivo utilizado) e gera faturas mensais para os assinantes, com status de cobrança (pendente, paga, atrasada ou estornada).

## 🗂️ Estrutura do repositório

```
cinestream-db/
├── README.md
├── .env.example          # modelo de variáveis de ambiente (sem valores reais)
├── .gitignore
├── sql/
│   ├── schema.sql        # script de criação das tabelas (DDL)
│   └── queries.sql       # 15 consultas SQL do projeto
└── docs/
    └── imagens/
        ├── modelo-conceitual.jpg
        └── modelo-relacional.jpg
```

## 🧩 Modelagem

### Esquema Conceitual

![Modelo Conceitual](docs/imagens/modelo-conceitual.svg)

🔗 Ver no brModelo: https://app.brmodeloweb.com/publicview/6a2083384d20e27be9030828

### Esquema Relacional

![Modelo Relacional](docs/imagens/modelo-relacional.svg)

🔗 Ver no brModelo: https://app.brmodeloweb.com/publicview/6a21ed07567a05fda7a9c843

## 🧱 Modelo de dados (tabelas)

| Tabela | Descrição |
|---|---|
| `Assinante` | Dados cadastrais dos assinantes |
| `QualidadeResolucao` | Domínio de qualidades (SD, FULL-HD, 4K) |
| `Plano` | Planos de assinatura oferecidos |
| `HistoricoAssinatura` | Histórico de planos contratados por assinante |
| `StatusCobranca` | Domínio de status de fatura |
| `Fatura` | Faturas mensais dos assinantes |
| `Dispositivo` | Dispositivos usados para assistir |
| `ClassificacaoMaturidade` | Domínio de classificação etária dos perfis |
| `Perfil` | Perfis dentro de uma conta de assinante |
| `Obra` | Filmes e séries do catálogo |
| `Visualizacao` | Registro de exibições assistidas por um perfil |
| `Genero` | Gêneros das obras |
| `ObraGenero` | Relação N:N entre obras e gêneros |
| `Profissional` | Atores e diretores |
| `ObraProfissional` | Relação N:N entre obras e profissionais |
| `Episodio` | Episódios de obras do tipo série |

O script completo de criação está em [`sql/schema.sql`](sql/schema.sql).

## 🔍 Consultas

O projeto inclui 15 consultas SQL cobrindo os principais casos de uso do sistema (assinantes ativos, faturas pendentes, obras sem visualização, ranking de gêneros, entre outras). Veja o arquivo completo em [`sql/queries.sql`](sql/queries.sql).

## ⚙️ Como executar

O banco foi desenvolvido e testado no **PostgreSQL** (hospedado no [Neon](https://neon.tech)), mas o script `schema.sql` é compatível com qualquer instância PostgreSQL.

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/cinestream-db.git
cd cinestream-db
```

### 2. Configure as credenciais

Crie seu próprio banco (por exemplo, gratuitamente no [Neon](https://neon.tech) ou localmente) e copie o arquivo de exemplo:

```bash
cp .env.example .env
```

Edite o `.env` com os dados de conexão do **seu** banco. Esse arquivo nunca deve ser enviado ao GitHub — ele já está listado no `.gitignore`.

### 3. Crie as tabelas

```bash
psql "postgresql://usuario:senha@host/banco?sslmode=require" -f sql/schema.sql
```

### 4. Rode as consultas

```bash
psql "postgresql://usuario:senha@host/banco?sslmode=require" -f sql/queries.sql
```


## 🛠️ Tecnologias

- PostgreSQL
- brModelo (modelagem conceitual e relacional)
- Neon (hospedagem do banco em nuvem)
