#!/bin/bash
# Development helper script for AI Software Engineer Docker Image

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

# Function to show usage
show_usage() {
    print_color $CYAN "AI Software Engineer - Development Script"
    echo ""
    print_color $YELLOW "Usage: $0 [command]"
    echo ""
    print_color $GREEN "Available commands:"
    echo "  setup        - Initial setup and build"
    echo "  build        - Build Docker image"
    echo "  run          - Run container interactively"
    echo "  dev          - Start development environment"
    echo "  test         - Run tests"
    echo "  clean        - Clean up Docker resources"
    echo "  logs         - View container logs"
    echo "  shell        - Enter running container"
    echo "  help         - Show this help"
    echo ""
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_color $RED "Error: Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Setup function
setup() {
    print_color $BLUE "Setting up AI Software Engineer development environment..."
    
    # Check Docker
    check_docker
    
    # Build image
    print_color $YELLOW "Building Docker image..."
    make build
    
    print_color $GREEN "✓ Setup completed successfully!"
    print_color $CYAN "You can now run: ./dev.sh dev"
}

# Build function
build() {
    print_color $BLUE "Building Docker image..."
    check_docker
    make build
    print_color $GREEN "✓ Build completed!"
}

# Run function
run() {
    print_color $BLUE "Running container interactively..."
    check_docker
    make run-interactive
}

# Development function
dev() {
    print_color $BLUE "Starting development environment..."
    check_docker
    make run-dev
}

# Test function
test() {
    print_color $BLUE "Running tests..."
    check_docker
    make test
    print_color $GREEN "✓ Tests completed!"
}

# Clean function
clean() {
    print_color $BLUE "Cleaning up Docker resources..."
    check_docker
    make clean-all
    print_color $GREEN "✓ Cleanup completed!"
}

# Logs function
logs() {
    print_color $BLUE "Viewing container logs..."
    check_docker
    make logs
}

# Shell function
shell() {
    print_color $BLUE "Entering container shell..."
    check_docker
    make exec
}

# Main logic
case "${1:-help}" in
    "setup")
        setup
        ;;
    "build")
        build
        ;;
    "run")
        run
        ;;
    "dev")
        dev
        ;;
    "test")
        test
        ;;
    "clean")
        clean
        ;;
    "logs")
        logs
        ;;
    "shell")
        shell
        ;;
    "help"|"-h"|"--help")
        show_usage
        ;;
    *)
        print_color $RED "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac