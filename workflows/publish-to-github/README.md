# Publish to GitHub Workflow

> Automatiza a publicação de projetos no GitHub

---

## O que faz?

Workflow completo para publicar qualquer diretório no GitHub:

1. **Valida** - Verifica pré-requisitos (gh CLI, estrutura)
2. **Prepara** - Inicializa git se necessário
3. **Commita** - Adiciona arquivos e cria commit
4. **Publica** - Cria repo no GitHub e faz push
5. **Verifica** - Confirma publicação e abre no navegador

---

## Instalação

```bash
# Via curl
curl -fsSL https://raw.githubusercontent.com/olucasalles/tools/main/install.sh | bash -s -- workflow publish-to-github

# Via clone
./install.sh workflow publish-to-github
```

---

## Uso

```
*workflow publish-to-github
```

O workflow vai perguntar:
1. Caminho do diretório
2. Org/username do GitHub
3. Nome do repositório
4. Visibilidade (public/private)
5. Mensagem de commit

---

## Pré-requisitos

- GitHub CLI instalado: `brew install gh`
- GitHub CLI autenticado: `gh auth login`
- Git instalado

---

## Exemplo

```
*workflow publish-to-github

> Origem: /Users/user/Projects/meu-projeto
> Org: meu-username
> Nome: meu-repo
> Visibilidade: public
> Commit: feat: initial release

✅ Publicado em: https://github.com/meu-username/meu-repo
```

---

## Autor

**Lucas Salles** - [@olucasalles](https://github.com/olucasalles)
