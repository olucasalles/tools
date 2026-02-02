# Extract Framework

> Task ID: extract-framework
> Agent: AIOS Master (Orion)
> Version: 1.0.0

---

## Execution Modes

**Choose your execution mode:**

### 1. YOLO Mode - Fast, Autonomous (0-1 prompts)
- Autonomous extraction with default settings
- Minimal user interaction
- **Best for:** Quick extractions, familiar source types

### 2. Interactive Mode - Balanced, Educational (5-10 prompts) **[DEFAULT]**
- Explicit checkpoints for each dimension
- User can adjust depth per section
- **Best for:** First-time extractions, complex sources

### 3. Pre-Flight Planning - Comprehensive Upfront Planning
- Full source analysis before extraction
- Zero ambiguity execution
- **Best for:** Large courses, multi-volume books, critical frameworks

**Parameter:** `mode` (optional, default: `interactive`)

---

## Task Definition (AIOS Task Format V1.0)

```yaml
task: extractFramework()
responsible: Orion (AIOS Master)
responsible_type: Agent
atomic_layer: Strategy

inputs:
  - field: source_type
    type: enum
    source: User Input
    required: true
    values:
      - book
      - lecture
      - video
      - paper
      - course
      - newsletter
      - clone
    validation: Must be one of the allowed values

  - field: source_content
    type: string | file
    source: User Input
    required: true
    validation: Non-empty content or valid file path

  - field: source_name
    type: string
    source: User Input
    required: true
    validation: Descriptive name for the source (used in output filename)

  - field: author
    type: string
    source: User Input
    required: false
    validation: Author/creator name

  - field: extraction_depth
    type: enum
    source: User Input
    required: false
    values:
      - quick      # Essential dimensions only (D1, D2, D6)
      - standard   # All 7 dimensions, moderate detail
      - deep       # Exhaustive extraction, maximum detail
    default: standard

  - field: output_format
    type: enum
    source: User Input
    required: false
    values:
      - markdown
      - json
      - yaml
    default: markdown

outputs:
  - field: framework_document
    type: file
    destination: docs/frameworks/{source_name}-framework.md
    persisted: true

  - field: implementation_checklist
    type: file
    destination: docs/frameworks/{source_name}-checklist.md
    persisted: true

  - field: clone_profile
    type: file
    destination: docs/frameworks/{source_name}-clone-profile.md
    persisted: true
    condition: source_type == 'clone'
```

---

## Pre-Conditions

**Purpose:** Validate prerequisites BEFORE task execution (blocking)

```yaml
pre-conditions:
  - [ ] Source content provided (text, file, or URL)
    type: pre-condition
    blocker: true
    validation: |
      Check source_content is non-empty
    error_message: "Pre-condition failed: No source content provided"

  - [ ] Source type identified
    type: pre-condition
    blocker: true
    validation: |
      Check source_type is valid enum value
    error_message: "Pre-condition failed: Invalid source type"

  - [ ] Output directory exists or can be created
    type: pre-condition
    blocker: false
    validation: |
      Check docs/frameworks/ directory
    error_message: "Warning: Output directory will be created"
```

---

## Post-Conditions

**Purpose:** Validate execution success AFTER task completes

```yaml
post-conditions:
  - [ ] Framework document created with all required dimensions
    type: post-condition
    blocker: true
    validation: |
      Verify framework file exists and contains D1-D7 sections
    error_message: "Post-condition failed: Incomplete framework document"

  - [ ] Implementation checklist generated
    type: post-condition
    blocker: false
    validation: |
      Verify checklist file exists
    error_message: "Warning: Checklist not generated"
```

---

## Acceptance Criteria

```yaml
acceptance-criteria:
  - [ ] All 7 dimensions extracted (or subset for quick mode)
    type: acceptance-criterion
    blocker: true

  - [ ] Source-specific extensions included
    type: acceptance-criterion
    blocker: true

  - [ ] Actionable implementation plan generated
    type: acceptance-criterion
    blocker: true

  - [ ] No hallucinated content (all from source)
    type: acceptance-criterion
    blocker: true
```

---

## Source Types Reference

| # | Type | Icon | Primary Focus | Dimensions Priority |
|---|------|------|---------------|---------------------|
| 1 | `book` | 📚 | Framework completo | All 7, full depth |
| 2 | `lecture` | 🎓 | Demonstrações práticas | D4, D6, D7 enhanced |
| 3 | `video` | 🎬 | Momentos-chave | D2, D6, D7 + timestamps |
| 4 | `paper` | 📄 | Metodologia rigorosa | D1, D5 + methodology ext |
| 5 | `course` | 📖 | Progressão pedagógica | D1, D6 + modules ext |
| 6 | `newsletter` | 📬 | Framework completo | All 7 + editorial ext |
| 7 | `clone` | 🧠 | Padrões de pensamento | D2, D3, D7 + persona ext |

---

## Interactive Elicitation Process

### Step 1: Source Identification

```
ELICIT: Source Type

Qual tipo de conteúdo você quer extrair o framework?

1. 📚 Livro
2. 🎓 Aula/Palestra
3. 🎬 Vídeo/Transcrição
4. 📄 Paper Científico
5. 📖 Curso Completo
6. 📬 Newsletter
7. 🧠 Clone Cognitivo (extrai personalidade + framework)

→ Digite o número ou nome do tipo
```

### Step 2: Source Content

```
ELICIT: Source Content

Como você vai fornecer o conteúdo?

1. 📋 Colar texto diretamente
2. 📁 Caminho do arquivo (PDF, TXT, MD)
3. 🔗 URL (tentarei extrair/transcrever)
4. 📎 Múltiplos arquivos (curso/newsletter archive)

→ Forneça o conteúdo após selecionar
```

### Step 3: Source Metadata

```
ELICIT: Source Information

1. Nome do conteúdo (ex: "O Almanaque de Naval Ravikant")
2. Autor/Criador (ex: "Eric Jorgenson")
3. Ano/Data (opcional)
4. Contexto adicional (opcional)

→ Essas informações ajudam na extração contextualizada
```

### Step 4: Extraction Depth

```
ELICIT: Extraction Depth

Qual profundidade de extração?

1. ⚡ Quick (15-20 min)
   - Dimensões essenciais: D1, D2, D6
   - Plano de implementação básico

2. 📊 Standard (30-45 min) [RECOMENDADO]
   - Todas as 7 dimensões
   - Extensões por tipo de fonte
   - Plano 30-60-90 dias

3. 🔬 Deep (60+ min)
   - Extração exaustiva
   - Múltiplas perspectivas
   - Cross-referencing interno
   - Gaps e contradições identificados

→ Digite 1, 2 ou 3
```

### Step 5: Confirmation

```
ELICIT: Confirm Extraction

📋 Resumo da Extração:
- Tipo: {source_type}
- Fonte: {source_name}
- Autor: {author}
- Profundidade: {extraction_depth}
- Output: docs/frameworks/{source_name}-framework.md

Confirma? (s/n)
```

---

## The 7 Dimensions Framework

### DIMENSÃO 1: FRAMEWORK COMPLETO DE IMPLEMENTAÇÃO

```markdown
## D1: Framework de Implementação

### Sumário Executivo Transformador
- Parágrafo 1: O problema central (com dados se mencionados)
- Parágrafo 2: A solução proposta e por que é única
- Parágrafo 3: A transformação prometida com exemplos

### Parte I: Arquitetura Conceitual

**1.1 Premissa Central**
- A grande sacada em uma frase
- Por que isso muda tudo

**1.2 Pilares Fundamentais (3-7)**
Para cada pilar:
- Nome do princípio
- Definição precisa do autor
- Por que é essencial
- Consequência de ignorar

**1.3 Modelos Mentais e Frameworks**
Para cada modelo:
- Nome exato usado
- Visualização (ASCII se possível)
- Como usar na prática
- Exemplo do conteúdo

**1.4 Mudanças de Paradigma**
Formato: "Antes: X → Agora: Y"

### Parte II: Sistema de Implementação

**2.1 Pré-Requisitos**
- [ ] Checklist do que DEVE estar pronto
- [ ] Recursos mínimos
- [ ] Mindset necessário
- [ ] Red flags: sinais de que NÃO está pronto

**2.2 Processo Sequencial**
FASE 1: [Nome] (Tempo estimado)
├─ Passo 1.1: [Ação]
│  └─ Como fazer: [Instruções]
│  └─ Resultado esperado: [Métrica]
├─ Passo 1.2: [...]
└─ Checkpoint: [Validação para próxima fase]

**2.3 Árvore de Decisão**
Situação: [Contexto]
├─ SE [condição A] → ENTÃO [ação X]
├─ SE [condição B] → ENTÃO [ação Y]
└─ SE [nenhuma] → ENTÃO [padrão]

**2.4 Métricas e KPIs**
- Leading indicators (progresso)
- Lagging indicators (resultado)
- Benchmarks: ruim/médio/bom/excelente

### Parte III: Ferramentas Práticas

**3.1 Templates Prontos**
- Template preenchível
- Exemplo do conteúdo
- Variações por contexto

**3.2 Checklists Operacionais**
- [ ] Diário
- [ ] Semanal
- [ ] Mensal (auditoria)
- [ ] Troubleshooting

**3.3 Scripts e Swipe Copy**
- Situação de uso
- Script palavra por palavra
- Variações sugeridas

**3.4 Exercícios e Drills**
- Nome do exercício
- Objetivo
- Passo a passo
- Tempo necessário
- Critério de sucesso
```

### DIMENSÃO 2: INSIGHTS REVOLUCIONÁRIOS

```markdown
## D2: Insights Revolucionários

### Os [5-10] Maiores Insights

**Insight #1: [Título Impactante]**
- Conceito em 2-3 frases
- Por que é revolucionário/contra-consenso
- Exemplo concreto (com números se houver)
- Como muda suas ações imediatamente
- Citação: "[...]" (localização)

[Repetir para cada insight]

### O Meta-Insight
O insight que conecta TODOS os outros - a sacada organizadora.
```

### DIMENSÃO 3: ASPECTOS CONTRA-INTUITIVOS

```markdown
## D3: Contra-Intuitivos

### [10-15] Paradoxos e Inversões

**#1: "[Título Provocativo]"**
- **Senso comum**: O que 99% acredita/faz
- **Realidade**: O que o autor prova
- **Evidência**: Dados, caso ou lógica
- **Implicação**: O que muda na ação

[Repetir para cada paradoxo]
```

### DIMENSÃO 4: HISTÓRIAS E CASOS

```markdown
## D4: Histórias e Casos

### Casos de Sucesso
Para cada caso:
- **Contexto inicial**: Situação antes
- **Intervenção**: O que foi feito
- **Resultados**: Números e prazos
- **Lição**: Princípio ilustrado

### Casos de Fracasso
- O que deu errado e por quê
- Princípio violado
- Como evitar

### História do Autor
- Momentos de descoberta
- Fracassos que levaram aos insights
- Transformação pessoal
```

### DIMENSÃO 5: NÚMEROS E FÓRMULAS

```markdown
## D5: Números e Fórmulas

### Métricas Mencionadas
- Benchmarks específicos
- Proporções importantes
- Metas numéricas
- Estatísticas fundamentais

### Fórmulas e Equações
- Fórmula: [transcrição exata]
- Variáveis: [significado de cada]
- Cálculo prático: [como usar]
- Exemplo resolvido: [números reais]

### Timeframes
- Tempo de cada fase
- Quando esperar resultados
- Marcos temporais críticos
```

### DIMENSÃO 6: APLICAÇÕES IMEDIATAS

```markdown
## D6: Aplicações Imediatas

### Em 2 HORAS (3-5 ações)
**Ação 1: [Nome]**
- Passo a passo em bullets
- Resultado esperado
- Princípio validado

### ESTA SEMANA (5-7 projetos)
**Projeto 1: [Nome]**
- Segunda: [ação]
- Terça-Quarta: [ação]
- Quinta-Sexta: [ação]
- Resultado mensurável

### ESTE MÊS (3-5 mudanças estruturais)
**Mudança 1: [Nome]**
- Semana 1: Preparação
- Semana 2: Implementação
- Semana 3: Otimização
- Semana 4: Consolidação
- Métrica de sucesso

### Hacks e Atalhos Ninja (5-10)
**Hack #1: [Nome Criativo]**
- O atalho explicado
- Por que funciona
- Quando usar vs evitar
```

### DIMENSÃO 7: CITAÇÕES E MANTRAS

```markdown
## D7: Citações e Mantras

### Citações de Transformação (7-10)
> "[Citação exata]" (localização)
> - Contexto: Quando foi dito
> - Aplicação: Use quando [situação]

### Mantras Operacionais
- "[Mantra 1]" → para [situação]
- "[Mantra 2]" → para [situação]

### Perguntas Poderosas
- [Pergunta] → ilumina [aspecto]
```

---

## Source-Specific Extensions

### 📚 BOOK Extension
```yaml
book_extension:
  structure_analysis:
    - Chapter breakdown with key points
    - Reading order recommendations
    - Skip-able sections identified

  cross_references:
    - Internal references mapped
    - External books/sources cited
    - Recommended reading order
```

### 🎓 LECTURE Extension
```yaml
lecture_extension:
  demonstration_moments:
    - Timestamp: [HH:MM:SS]
    - What was demonstrated
    - Key technique shown

  qa_insights:
    - Questions asked by audience
    - Answers that revealed extra depth

  live_examples:
    - Real-time exercises performed
    - Audience participation moments
```

### 🎬 VIDEO Extension
```yaml
video_extension:
  timestamps:
    - [00:00] Introduction
    - [MM:SS] Key concept 1
    - [MM:SS] Actionable tip
    - [MM:SS] Summary

  visual_elements:
    - Diagrams shown (describe)
    - On-screen text captured
    - B-roll context

  cta_analysis:
    - What viewer is asked to do
    - Resources mentioned
    - Links/tools referenced
```

### 📄 PAPER Extension
```yaml
paper_extension:
  methodology:
    - Study design
    - Sample size and selection
    - Variables measured
    - Statistical methods

  results_summary:
    - Key findings (with p-values)
    - Effect sizes
    - Confidence intervals

  limitations:
    - Acknowledged by authors
    - Identified gaps
    - Generalizability concerns

  practical_implications:
    - What practitioners should do
    - What needs more research
    - Conditions for application
```

### 📖 COURSE Extension
```yaml
course_extension:
  module_structure:
    - Module 1: [Name]
      - Lessons: [list]
      - Prerequisites: [what to know first]
      - Outcome: [what you can do after]

  progression_path:
    - Beginner track: Modules [X, Y, Z]
    - Intermediate track: Modules [A, B, C]
    - Advanced track: Modules [D, E, F]

  exercises_by_module:
    - Module X Exercise 1: [description]
    - Difficulty: [easy/medium/hard]
    - Time required: [estimate]

  certification_criteria:
    - What defines completion
    - Assessment methods
    - Skill validation
```

### 📬 NEWSLETTER Extension
```yaml
newsletter_extension:
  editorial_patterns:
    - Typical structure (intro, body, CTA)
    - Opening hooks used
    - Subject line patterns
    - Send frequency and timing

  content_strategy:
    - Top 5 recurring themes
    - Frequently cited sources
    - Preferred format (listicle, essay, curation)
    - Content/promotion ratio

  voice_extraction:
    - Tone (casual, authoritative, friendly)
    - Characteristic expressions
    - How editions open/close
    - Author personality markers

  growth_insights:
    - Subscriber milestones mentioned
    - What content performed best
    - Engagement patterns noted
```

### 🧠 CLONE Extension
```yaml
clone_extension:
  persona_extraction:
    vocabulary:
      - Characteristic words/phrases
      - Technical terms preferred
      - Expressions to avoid

    communication_style:
      - Tone spectrum (formal ←→ casual)
      - Emoji usage (never/rare/frequent)
      - Sentence length preference
      - Paragraph structure

    argumentation_patterns:
      - How they build arguments
      - Evidence types preferred
      - Counterargument handling

  cognitive_patterns:
    problem_approach:
      - First principles vs analogies
      - Data-driven vs intuition
      - Risk tolerance level

    reasoning_sequence:
      - How they start analysis
      - Decision-making framework
      - Validation methods

    mental_models:
      - Frameworks frequently used
      - Metaphors preferred
      - Reference domains

  belief_system:
    core_beliefs:
      - Fundamental assumptions
      - Non-negotiables
      - Values hierarchy

    declared_biases:
      - What they admit favoring
      - What they openly dismiss
      - Controversial positions

    knowledge_domains:
      - Primary expertise areas
      - Secondary interests
      - Acknowledged blind spots

  interaction_patterns:
    greeting_style: "[typical greeting]"
    closing_style: "[typical sign-off]"
    humor_type: "[dry/witty/none/self-deprecating]"
    empathy_expression: "[how they show understanding]"
```

---

## Implementation Steps

### 1. Validate Inputs
```javascript
// Pseudo-code for validation
if (!source_content) throw "No content provided";
if (!source_type in VALID_TYPES) throw "Invalid source type";
if (!source_name) source_name = generateFromContent(source_content);
```

### 2. Pre-Process Content
- For files: Extract text (PDF, DOCX, etc.)
- For URLs: Fetch and extract main content
- For videos: Check for transcript availability
- Normalize encoding and formatting

### 3. Execute Dimensional Analysis
```
FOR each dimension IN [D1, D2, D3, D4, D5, D6, D7]:
  IF extraction_depth == 'quick' AND dimension NOT IN [D1, D2, D6]:
    SKIP dimension
  ELSE:
    EXTRACT dimension content
    APPLY source-specific adaptations
    VALIDATE against source (no hallucination)
```

### 4. Apply Source Extensions
```
LOAD extension FOR source_type
EXTRACT extension-specific content
MERGE with base dimensions
```

### 5. Generate Outputs
- Framework document (markdown/json/yaml)
- Implementation checklist
- Clone profile (if source_type == 'clone')

### 6. Quality Validation
- Cross-reference all citations
- Verify no hallucinated content
- Check completeness per depth level

---

## Output Templates

### Framework Document Structure
```markdown
# {source_name} - Framework Extraído

> Fonte: {source_type}
> Autor: {author}
> Extraído em: {date}
> Profundidade: {extraction_depth}

---

## Sumário Executivo
[3 parágrafos transformadores]

---

## D1: Framework de Implementação
[...]

## D2: Insights Revolucionários
[...]

## D3: Contra-Intuitivos
[...]

## D4: Histórias e Casos
[...]

## D5: Números e Fórmulas
[...]

## D6: Aplicações Imediatas
[...]

## D7: Citações e Mantras
[...]

---

## Extensões: {source_type}
[source-specific content]

---

## Plano 30-60-90 Dias
[implementation roadmap]

---

## Avisos e Armadilhas
[common mistakes to avoid]

---

*Extraído via AIOS extract-framework task v1.0*
```

---

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| Empty content | No text extracted | Check file format, try alternative extraction |
| Too short | Content < 500 words | Warn user, suggest 'quick' depth |
| Too long | Content > 100k tokens | Chunk and process iteratively |
| No structure | Unstructured content | Apply best-effort extraction with warnings |
| Language mismatch | Non-Portuguese content | Translate or extract in original language |

---

## Performance

```yaml
duration_expected:
  quick: 15-20 min
  standard: 30-45 min
  deep: 60-90 min

token_usage:
  quick: ~5,000-10,000 tokens
  standard: ~15,000-30,000 tokens
  deep: ~40,000-80,000 tokens
```

---

## Metadata

```yaml
task: extract-framework
version: 1.0.0
created: 2025-02-02
author: Orion (AIOS Master)
tags:
  - extraction
  - framework
  - knowledge-management
  - clone
dependencies:
  templates:
    - framework-output-tmpl.md
  data:
    - extraction-dimensions.md
```

---

## Usage Examples

### Example 1: Extract from Book
```
*task extract-framework

> Tipo: 1 (Livro)
> Conteúdo: [cola texto ou caminho do PDF]
> Nome: "O Almanaque de Naval Ravikant"
> Autor: Eric Jorgenson
> Profundidade: 2 (Standard)
```

### Example 2: Extract for Clone
```
*task extract-framework

> Tipo: 7 (Clone Cognitivo)
> Conteúdo: [transcrições de podcasts + newsletters]
> Nome: "Dan Koe"
> Profundidade: 3 (Deep)

→ Gera framework + perfil de clone para uso com /clone
```

### Example 3: Quick Newsletter Analysis
```
*task extract-framework

> Tipo: 6 (Newsletter)
> Conteúdo: [arquivo com 10 edições]
> Nome: "O Novo Mercado"
> Profundidade: 1 (Quick)
```

---

## Success Output

```
✅ Framework extraído com sucesso!

📁 Arquivos gerados:
   → docs/frameworks/{source_name}-framework.md
   → docs/frameworks/{source_name}-checklist.md
   {IF clone} → docs/frameworks/{source_name}-clone-profile.md

📊 Estatísticas:
   - Dimensões extraídas: 7/7
   - Insights identificados: {N}
   - Ações práticas: {N}
   - Citações capturadas: {N}

🚀 Próximos passos sugeridos:
   1. Revisar Sumário Executivo
   2. Iniciar ações de 2 horas (D6)
   3. Configurar plano 30-60-90 dias
```
