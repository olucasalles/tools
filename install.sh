#!/bin/bash

# ============================================
# AIOS Tools Installer
# https://github.com/olucasalles/tools
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Config
REPO_URL="https://github.com/olucasalles/tools"
RAW_URL="https://raw.githubusercontent.com/olucasalles/tools/main"
AIOS_CORE=".aios-core"

# ============================================
# Helper Functions
# ============================================

print_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║         AIOS Tools Installer          ║"
    echo "║     github.com/olucasalles/tools      ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_aios() {
    if [ ! -d "$AIOS_CORE" ]; then
        log_error "Diretório $AIOS_CORE não encontrado!"
        log_info "Este comando deve ser executado na raiz de um projeto AIOS."
        log_info "Certifique-se de que o projeto tem a estrutura AIOS configurada."
        exit 1
    fi
    log_success "Projeto AIOS detectado"
}

get_destination() {
    local type=$1
    case $type in
        task|tasks)
            echo "$AIOS_CORE/development/tasks"
            ;;
        workflow|workflows)
            echo "$AIOS_CORE/development/workflows"
            ;;
        template|templates)
            echo "$AIOS_CORE/product/templates"
            ;;
        agent|agents)
            echo "$AIOS_CORE/development/agents"
            ;;
        *)
            log_error "Tipo desconhecido: $type"
            log_info "Tipos válidos: task, workflow, template, agent"
            exit 1
            ;;
    esac
}

# ============================================
# Installation Functions
# ============================================

install_component() {
    local type=$1
    local name=$2
    local dest=$(get_destination $type)
    local source_dir=""
    local source_file=""

    # Normalize type to plural for directory
    case $type in
        task) source_dir="tasks" ;;
        workflow) source_dir="workflows" ;;
        template) source_dir="templates" ;;
        agent) source_dir="agents" ;;
        *) source_dir="${type}s" ;;
    esac

    log_info "Instalando $type: $name"

    # Check if running from cloned repo or remote
    if [ -f "./${source_dir}/${name}/${name}.md" ]; then
        # Local installation
        source_file="./${source_dir}/${name}/${name}.md"
        log_info "Fonte: local"
    else
        # Remote installation
        source_file="/tmp/aios-tools-${name}.md"
        log_info "Fonte: remota"
        log_info "Baixando de $RAW_URL/${source_dir}/${name}/${name}.md"

        if ! curl -fsSL "$RAW_URL/${source_dir}/${name}/${name}.md" -o "$source_file" 2>/dev/null; then
            log_error "Falha ao baixar $name"
            log_info "Verifique se o componente existe: $REPO_URL/tree/main/${source_dir}/${name}"
            exit 1
        fi
    fi

    # Create destination directory if needed
    mkdir -p "$dest"

    # Check if already exists
    if [ -f "$dest/${name}.md" ]; then
        log_warn "Arquivo já existe: $dest/${name}.md"
        read -p "Sobrescrever? (s/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_info "Instalação cancelada"
            exit 0
        fi
    fi

    # Copy file
    cp "$source_file" "$dest/${name}.md"

    # Cleanup temp file if remote
    if [[ "$source_file" == /tmp/* ]]; then
        rm -f "$source_file"
    fi

    log_success "Instalado em: $dest/${name}.md"
}

list_components() {
    echo -e "${CYAN}Componentes Disponíveis:${NC}"
    echo ""

    echo -e "${YELLOW}Tasks:${NC}"
    echo "  - extract-framework    Extrai frameworks de livros, vídeos, newsletters, etc."
    echo ""

    echo -e "${YELLOW}Workflows:${NC}"
    echo "  - publish-to-github    Publica projetos no GitHub automaticamente"
    echo ""

    echo -e "${YELLOW}Templates:${NC}"
    echo "  (em breve)"
    echo ""

    echo -e "${YELLOW}Agents:${NC}"
    echo "  (em breve)"
    echo ""

    echo -e "${BLUE}Para instalar:${NC}"
    echo "  ./install.sh task extract-framework"
    echo "  ./install.sh workflow publish-to-github"
}

show_help() {
    echo "Uso: ./install.sh <comando> [argumentos]"
    echo ""
    echo "Comandos:"
    echo "  task <nome>       Instala uma task"
    echo "  workflow <nome>   Instala um workflow"
    echo "  template <nome>   Instala um template"
    echo "  agent <nome>      Instala um agent"
    echo "  list              Lista componentes disponíveis"
    echo "  update <tipo> <nome>  Atualiza componente instalado"
    echo "  help              Mostra esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  ./install.sh task extract-framework"
    echo "  ./install.sh list"
    echo "  ./install.sh update task extract-framework"
    echo ""
    echo "Instalação remota (sem clone):"
    echo "  curl -fsSL $RAW_URL/install.sh | bash -s -- task extract-framework"
}

# ============================================
# Main
# ============================================

main() {
    print_banner

    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    local command=$1
    shift

    case $command in
        task|workflow|template|agent)
            if [ -z "$1" ]; then
                log_error "Nome do componente não especificado"
                log_info "Uso: ./install.sh $command <nome>"
                exit 1
            fi
            check_aios
            install_component "$command" "$1"
            ;;
        list)
            list_components
            ;;
        update)
            if [ -z "$1" ] || [ -z "$2" ]; then
                log_error "Especifique tipo e nome"
                log_info "Uso: ./install.sh update <tipo> <nome>"
                exit 1
            fi
            check_aios
            log_info "Atualizando $1: $2"
            install_component "$1" "$2"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Comando desconhecido: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
