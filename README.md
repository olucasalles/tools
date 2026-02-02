# AIOS Tools

> Coleção de tasks, workflows, templates e agentes para Synkra AIOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Instalação Rápida

```bash
# Instalar ferramenta específica
curl -fsSL https://raw.githubusercontent.com/olucasalles/tools/main/install.sh | bash -s -- task extract-framework

# Ou clone e instale localmente
git clone https://github.com/olucasalles/tools.git
cd tools
./install.sh task extract-framework
```

---

## Catálogo

### Tasks

| Task | Descrição | Comando |
|------|-----------|---------|
| [extract-framework](./tasks/extract-framework/) | Extrai frameworks completos de livros, newsletters, vídeos, papers, cursos e para clones cognitivos | `./install.sh task extract-framework` |

### Workflows

| Workflow | Descrição | Comando |
|----------|-----------|---------|
| *Em breve* | - | - |

### Templates

| Template | Descrição | Comando |
|----------|-----------|---------|
| *Em breve* | - | - |

### Agents

| Agent | Descrição | Comando |
|-------|-----------|---------|
| *Em breve* | - | - |

---

## Como Usar

### Pré-requisitos

- Projeto com AIOS configurado (`.aios-core/` existente)
- Git instalado
- Bash (Linux/macOS/WSL)

### Instalação de Componentes

```bash
# Sintaxe
./install.sh <tipo> <nome>

# Tipos disponíveis:
#   task      → instala em .aios-core/development/tasks/
#   workflow  → instala em .aios-core/development/workflows/
#   template  → instala em .aios-core/product/templates/
#   agent     → instala em .aios-core/development/agents/

# Exemplos:
./install.sh task extract-framework
./install.sh workflow brownfield-analysis
./install.sh template prd-advanced
./install.sh agent research-specialist
```

### Instalação Remota (sem clone)

```bash
# Task específica
curl -fsSL https://raw.githubusercontent.com/olucasalles/tools/main/install.sh | bash -s -- task extract-framework

# Listar disponíveis
curl -fsSL https://raw.githubusercontent.com/olucasalles/tools/main/install.sh | bash -s -- list
```

### Atualização

```bash
# Atualizar componente já instalado
./install.sh update task extract-framework

# Atualizar todos
./install.sh update all
```

---

## Estrutura do Repositório

```
tools/
├── README.md                 # Este arquivo
├── install.sh                # Instalador universal
├── tasks/
│   └── extract-framework/
│       ├── README.md         # Documentação da task
│       └── extract-framework.md
├── workflows/
│   └── [futuros workflows]
├── templates/
│   └── [futuros templates]
├── agents/
│   └── [futuros agents]
└── scripts/
    └── [utilitários]
```

---

## Criando Novos Componentes

### Estrutura de uma Task

```
tasks/
└── minha-task/
    ├── README.md              # Obrigatório: documentação
    └── minha-task.md          # Obrigatório: arquivo da task
```

### Estrutura de um Workflow

```
workflows/
└── meu-workflow/
    ├── README.md              # Obrigatório: documentação
    └── meu-workflow.md        # Obrigatório: arquivo do workflow
```

---

## Contribuindo

1. Fork este repositório
2. Crie sua branch: `git checkout -b feat/nova-task`
3. Adicione seu componente seguindo a estrutura
4. Commit: `git commit -m "feat: add nova-task"`
5. Push: `git push origin feat/nova-task`
6. Abra um Pull Request

---

## Compatibilidade

| AIOS Version | Tools Version | Status |
|--------------|---------------|--------|
| 2.x | 1.x | Compatível |
| 1.x | 1.x | Compatível |

---

## Licença

MIT License - veja [LICENSE](./LICENSE) para detalhes.

---

## Autor

**Lucas Salles** - [@olucasalles](https://github.com/olucasalles)

---

*Parte do ecossistema Synkra AIOS*
