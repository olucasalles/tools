# Publish to GitHub

> Workflow ID: publish-to-github
> Version: 1.0.0

---

## Descrição

Workflow para publicar projetos/repos no GitHub de forma padronizada. Automatiza:
- Validação da estrutura
- Inicialização do git
- Commit inicial
- Criação do repo no GitHub
- Push inicial

---

## Pré-requisitos

```yaml
prerequisites:
  - GitHub CLI instalado e autenticado (gh auth status)
  - Git instalado
  - Diretório com arquivos para publicar
  - README.md presente (recomendado)
```

---

## Inputs

```yaml
inputs:
  - field: source_path
    type: string
    required: true
    description: Caminho do diretório a publicar
    example: /Users/user/Projects/meu-projeto

  - field: repo_org
    type: string
    required: true
    description: Organização ou username do GitHub
    example: olucasalles

  - field: repo_name
    type: string
    required: true
    description: Nome do repositório
    example: tools

  - field: visibility
    type: enum
    values: [public, private]
    default: public
    description: Visibilidade do repositório

  - field: description
    type: string
    required: false
    description: Descrição do repositório

  - field: commit_message
    type: string
    default: "feat: initial release"
    description: Mensagem do commit inicial
```

---

## Interactive Elicitation

### Step 1: Identificar Projeto

```
ELICIT: Source Project

Qual diretório você quer publicar no GitHub?

→ Informe o caminho completo
  Exemplo: /Users/lucassales/Projects/meu-projeto
```

### Step 2: Configurar Repositório

```
ELICIT: Repository Config

1. Organização/Username: (ex: olucasalles)
2. Nome do repo: (ex: tools)
3. Visibilidade:
   - 1. Public (recomendado para open source)
   - 2. Private
4. Descrição (opcional):
```

### Step 3: Configurar Commit

```
ELICIT: Commit Config

Mensagem do commit inicial:
→ Default: "feat: initial release"
→ Ou digite sua mensagem personalizada
```

### Step 4: Confirmação

```
ELICIT: Confirm

📋 Resumo da Publicação:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Origem:      {source_path}
🔗 Destino:     github.com/{repo_org}/{repo_name}
👁️ Visibilidade: {visibility}
📝 Commit:      {commit_message}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Confirma publicação? (s/n)
```

---

## Workflow Steps

### FASE 1: Validação

```yaml
phase: validation
steps:
  - step: 1.1
    name: Verificar GitHub CLI
    action: |
      gh auth status
    on_error: |
      echo "GitHub CLI não autenticado"
      echo "Execute: gh auth login"
      exit 1

  - step: 1.2
    name: Verificar diretório
    action: |
      if [ ! -d "{source_path}" ]; then
        echo "Diretório não encontrado: {source_path}"
        exit 1
      fi

  - step: 1.3
    name: Verificar README
    action: |
      if [ ! -f "{source_path}/README.md" ]; then
        echo "⚠️ AVISO: README.md não encontrado"
        echo "Recomendado ter um README.md"
      fi

checkpoint: "Validação completa"
```

### FASE 2: Preparação Git

```yaml
phase: git_setup
steps:
  - step: 2.1
    name: Entrar no diretório
    action: |
      cd {source_path}

  - step: 2.2
    name: Verificar/Inicializar Git
    action: |
      if [ ! -d ".git" ]; then
        git init
        echo "✅ Git inicializado"
      else
        echo "✅ Git já inicializado"
      fi

  - step: 2.3
    name: Configurar branch main
    action: |
      git branch -M main

checkpoint: "Git preparado"
```

### FASE 3: Commit

```yaml
phase: commit
steps:
  - step: 3.1
    name: Adicionar arquivos
    action: |
      git add .
      echo "✅ Arquivos adicionados"

  - step: 3.2
    name: Criar commit
    action: |
      git commit -m "{commit_message}

      Co-Authored-By: Claude <noreply@anthropic.com>"
    on_error: |
      echo "Nada para commitar ou erro no commit"

checkpoint: "Commit criado"
```

### FASE 4: Publicação

```yaml
phase: publish
steps:
  - step: 4.1
    name: Verificar se repo existe
    action: |
      if gh repo view {repo_org}/{repo_name} &>/dev/null; then
        echo "⚠️ Repositório já existe"
        echo "Conectando ao repo existente..."
        REPO_EXISTS=true
      else
        REPO_EXISTS=false
      fi

  - step: 4.2
    name: Criar repositório (se não existe)
    condition: REPO_EXISTS == false
    action: |
      gh repo create {repo_org}/{repo_name} \
        --{visibility} \
        --source=. \
        --remote=origin \
        --description="{description}"
      echo "✅ Repositório criado"

  - step: 4.3
    name: Conectar repo existente
    condition: REPO_EXISTS == true
    action: |
      git remote remove origin 2>/dev/null || true
      git remote add origin https://github.com/{repo_org}/{repo_name}.git
      echo "✅ Remote configurado"

  - step: 4.4
    name: Push inicial
    action: |
      git push -u origin main
      echo "✅ Push realizado"

checkpoint: "Publicado no GitHub"
```

### FASE 5: Verificação

```yaml
phase: verification
steps:
  - step: 5.1
    name: Confirmar publicação
    action: |
      gh repo view {repo_org}/{repo_name} --web

  - step: 5.2
    name: Mostrar resumo
    action: |
      echo ""
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "✅ PUBLICAÇÃO CONCLUÍDA!"
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo ""
      echo "🔗 URL: https://github.com/{repo_org}/{repo_name}"
      echo ""
      echo "📋 Próximos passos sugeridos:"
      echo "   1. Verificar o repo no navegador"
      echo "   2. Configurar branch protection (se necessário)"
      echo "   3. Adicionar topics/tags"
      echo "   4. Compartilhar!"
      echo ""
```

---

## Error Handling

| Erro | Causa | Resolução |
|------|-------|-----------|
| `gh: command not found` | GitHub CLI não instalado | `brew install gh` |
| `not logged into any GitHub hosts` | Não autenticado | `gh auth login` |
| `repository already exists` | Repo já existe | Conecta ao existente |
| `Permission denied` | Sem permissão na org | Verificar acesso |
| `nothing to commit` | Sem mudanças | Normal se já commitado |

---

## Outputs

```yaml
outputs:
  - field: repo_url
    type: string
    value: https://github.com/{repo_org}/{repo_name}

  - field: clone_command
    type: string
    value: git clone https://github.com/{repo_org}/{repo_name}.git

  - field: success
    type: boolean
```

---

## Success Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PUBLICAÇÃO CONCLUÍDA!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔗 URL: https://github.com/{repo_org}/{repo_name}

📋 Comandos úteis:
   Clone: git clone https://github.com/{repo_org}/{repo_name}.git

📋 Próximos passos:
   1. Verificar o repo no navegador
   2. Configurar branch protection
   3. Adicionar topics/tags
   4. Compartilhar!
```

---

## Exemplos de Uso

### Exemplo 1: Publicar tools repo

```
*workflow publish-to-github

> Origem: /Users/lucassales/Projects/projetos-originais-IA/.tools-repo
> Org: olucasalles
> Nome: tools
> Visibilidade: 1 (public)
> Commit: feat: initial release with extract-framework task
```

### Exemplo 2: Publicar projeto privado

```
*workflow publish-to-github

> Origem: /Users/lucassales/Projects/meu-projeto-secreto
> Org: olucasalles
> Nome: projeto-secreto
> Visibilidade: 2 (private)
> Commit: chore: initial setup
```

---

## Metadata

```yaml
workflow: publish-to-github
version: 1.0.0
created: 2025-02-02
author: Orion (AIOS Master)
tags:
  - git
  - github
  - devops
  - automation
```
