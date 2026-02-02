# Extract Framework

> Extrai frameworks completos de implementação de qualquer fonte de conhecimento

---

## O que faz?

Transforma conteúdo denso (livros, cursos, newsletters, papers, vídeos) em frameworks acionáveis com:

- **7 Dimensões de Extração**: Framework, Insights, Contra-intuitivos, Casos, Números, Aplicações, Citações
- **Plano de Implementação**: 30-60-90 dias com ações específicas
- **Extensões por Tipo**: Adaptações específicas para cada tipo de fonte
- **Suporte a Clones**: Extrai padrões de pensamento para clonagem cognitiva

---

## Tipos de Fonte Suportados

| Tipo | Descrição | Foco |
|------|-----------|------|
| `book` | Livros completos | Framework completo |
| `lecture` | Aulas e palestras | Demonstrações práticas |
| `video` | Vídeos e transcrições | Momentos-chave + timestamps |
| `paper` | Papers científicos | Metodologia + dados |
| `course` | Cursos completos | Progressão pedagógica |
| `newsletter` | Newsletters/boletins | Framework completo + padrões editoriais |
| `clone` | Para clonagem cognitiva | Personalidade + padrões de pensamento |

---

## Instalação

```bash
# Via curl (remoto)
curl -fsSL https://raw.githubusercontent.com/olucasalles/tools/main/install.sh | bash -s -- task extract-framework

# Via clone local
git clone https://github.com/olucasalles/tools.git
cd tools
./install.sh task extract-framework
```

---

## Uso

Após instalar, no seu projeto AIOS:

```
*task extract-framework
```

### Fluxo Interativo

1. **Selecione o tipo de fonte** (1-7)
2. **Forneça o conteúdo** (texto, arquivo, ou URL)
3. **Informe metadados** (nome, autor)
4. **Escolha profundidade** (quick/standard/deep)
5. **Confirme e execute**

### Exemplo Rápido

```
*task extract-framework

> Tipo: 1 (Livro)
> Conteúdo: [texto do livro]
> Nome: "O Almanaque de Naval Ravikant"
> Autor: Eric Jorgenson
> Profundidade: 2 (Standard)
```

---

## Output

A task gera os seguintes arquivos:

```
docs/frameworks/
├── {nome}-framework.md      # Framework completo (7 dimensões)
├── {nome}-checklist.md      # Checklist de implementação
└── {nome}-clone-profile.md  # Perfil para clone (se tipo=clone)
```

---

## As 7 Dimensões

### D1: Framework de Implementação
- Sumário executivo transformador
- Arquitetura conceitual (premissa, pilares, modelos)
- Sistema de implementação (pré-requisitos, processo, decisões, métricas)
- Ferramentas práticas (templates, checklists, scripts, exercícios)

### D2: Insights Revolucionários
- Os 5-10 maiores insights
- O meta-insight organizador

### D3: Contra-Intuitivos
- 10-15 paradoxos e inversões de lógica
- Senso comum vs realidade

### D4: Histórias e Casos
- Casos de sucesso detalhados
- Casos de fracasso instrutivos
- História pessoal do autor

### D5: Números e Fórmulas
- Métricas e benchmarks
- Fórmulas e equações
- Timeframes e prazos

### D6: Aplicações Imediatas
- Em 2 horas (3-5 ações)
- Esta semana (5-7 projetos)
- Este mês (3-5 mudanças)
- Hacks e atalhos ninja

### D7: Citações e Mantras
- Citações de transformação
- Mantras operacionais
- Perguntas poderosas

---

## Níveis de Profundidade

| Nível | Tempo | Dimensões | Uso |
|-------|-------|-----------|-----|
| `quick` | 15-20 min | D1, D2, D6 | Análise rápida |
| `standard` | 30-45 min | Todas (7) | Uso geral |
| `deep` | 60-90 min | Todas + cross-ref | Frameworks críticos |

---

## Extensão para Clones

Quando `source_type = clone`, adiciona extração de:

- **Persona**: vocabulário, tom, expressões
- **Padrões Cognitivos**: como aborda problemas, sequência de raciocínio
- **Sistema de Crenças**: valores, vieses declarados, posições

Útil para usar com a skill `/clone` do AIOS.

---

## Requisitos

- Projeto com AIOS configurado (`.aios-core/`)
- Conteúdo fonte (texto, PDF, ou URL)

---

## Changelog

### v1.0.0 (2025-02-02)
- Release inicial
- 7 tipos de fonte suportados
- 7 dimensões de extração
- Integração com clones cognitivos

---

## Autor

**Lucas Salles** - [@olucasalles](https://github.com/olucasalles)

---

## Licença

MIT
