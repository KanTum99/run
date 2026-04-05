#!/bin/bash

# Set vibrant colors
RED='[31m'
GREEN='[32m'
BLUE='[34m'
YELLOW='[33m'
RESET='[0m'

# Define padding
PADDING="    "

# Function to print a message with padding and color
print_padded_message() {
    local color=$1
    local message=$2
    echo -e "${PADDING}${color}${message}${RESET}"
}

# Print beautiful AI UI components for Termux
clear
print_padded_message $GREEN "Welcome to the Beautiful AI UI for Termux!"
print_padded_message $BLUE "=============================="

# Example components
print_padded_message $YELLOW "1. Input your command below:"
print_padded_message $RED "✨ Vibrant Text ✨"
print_padded_message $GREEN "=============================="
# Additional components can be added here

# Example command to input
read -p "${PADDING}Enter your command: " userInput
print_padded_message $BLUE "You entered: $userInput"

# Finished
print_padded_message $GREEN "Thank you for using the AI UI!"
