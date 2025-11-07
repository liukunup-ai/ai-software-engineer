#!/bin/bash
# Docker container entrypoint script for AI Software Engineer

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print banner
print_banner() {
    echo
    print_color $CYAN "╔══════════════════════════════════════════════════════════════╗"
    print_color $CYAN "║                  AI Software Engineer                        ║"
    print_color $CYAN "║              Docker Environment Ready                        ║"
    print_color $CYAN "╚══════════════════════════════════════════════════════════════╝"
    echo
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display available tools
show_tools() {
    echo
    print_color $YELLOW "Available AI Coding Assistant Tools:"
    echo "┌─────────────────────────────────────────────────────────────┐"
    
    if command_exists gh; then
        if gh extension list | grep -q copilot; then
            print_color $GREEN "✓ GitHub Copilot CLI      : gh copilot suggest 'your task'"
        else
            print_color $RED "✗ GitHub Copilot CLI      : Extension not installed"
        fi
    else
        print_color $RED "✗ GitHub Copilot CLI      : GitHub CLI not installed"
    fi
    
    if command_exists qoder; then
        print_color $GREEN "✓ Alibaba Qoder CLI       : qoder help"
    else
        print_color $YELLOW "◐ Alibaba Qoder CLI       : qoder help (wrapper)"
    fi
    
    if command_exists cursor; then
        print_color $YELLOW "◐ Cursor CLI              : cursor help (wrapper)"
    else
        print_color $RED "✗ Cursor CLI              : Not installed"
    fi
    
    if command_exists trae; then
        print_color $YELLOW "◐ ByteDance Trae CLI      : trae help (wrapper)"
    else
        print_color $RED "✗ ByteDance Trae CLI      : Not installed"
    fi
    
    echo "└─────────────────────────────────────────────────────────────┘"
    echo
}

# Function to display usage information
show_usage() {
    print_color $BLUE "Usage Examples:"
    echo
    echo "GitHub Copilot:"
    echo "  gh auth login                    # Authenticate with GitHub"
    echo "  gh copilot suggest 'create a Python function to read CSV'"
    echo "  gh copilot explain 'git rebase'"
    echo
    echo "Other Tools:"
    echo "  qoder help                       # Show Qoder help"
    echo "  cursor help                      # Show Cursor help"
    echo "  trae help                        # Show Trae help"
    echo
    print_color $PURPLE "System Tools:"
    echo "  git --version                    # Check Git version"
    echo "  node --version                   # Check Node.js version"
    echo "  python3 --version                # Check Python version"
    echo "  npm --version                    # Check npm version"
    echo
}

# Function to run health checks
health_check() {
    print_color $BLUE "Running health checks..."
    echo
    
    # Check system tools
    local tools=("git" "node" "python3" "npm" "curl" "wget")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version=$($tool --version 2>/dev/null | head -n1 || echo "unknown")
            print_color $GREEN "✓ $tool: $version"
        else
            print_color $RED "✗ $tool: Not found"
        fi
    done
    echo
}

# Main function
main() {
    print_banner
    
    # Show environment information
    print_color $CYAN "Environment Information:"
    echo "  User: $(whoami)"
    echo "  Home: $HOME"
    echo "  Working Directory: $(pwd)"
    echo "  Shell: $SHELL"
    echo
    
    # Run health checks
    health_check
    
    # Show available tools
    show_tools
    
    # Show usage examples
    show_usage
    
    # Setup message
    print_color $YELLOW "Setup Notes:"
    echo "  • For GitHub Copilot, run 'gh auth login' to authenticate"
    echo "  • Some CLI tools may need additional configuration"
    echo "  • Check individual tool documentation for advanced usage"
    echo
    
    # Execute the passed command or start an interactive shell
    if [ $# -eq 0 ]; then
        print_color $GREEN "Starting interactive bash shell..."
        exec bash
    else
        print_color $GREEN "Executing command: $*"
        exec "$@"
    fi
}

# Run main function with all arguments
main "$@"