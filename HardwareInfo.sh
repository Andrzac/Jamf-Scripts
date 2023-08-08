#!/bin/bash

####
# This script is used to check hardware information if the correct information isn't reporting in the MDM. 
#Also in Self Service so end users can run the policy and provide information to the techs.
# By Zach Andreae
# 5/07/23
####

# Function to print horizontal line
function print_line() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

# Function to display basic system information
function display_system_info() {
    echo "System Information:"
    print_line

    echo "Hostname: $(hostname)"
    echo "OS Version: $(sw_vers -productVersion)"
    echo "Kernel Version: $(uname -r)"
    echo "Machine Model: $(sysctl -n hw.model)"
    echo "Processor: $(sysctl -n machdep.cpu.brand_string)"
    echo "Physical Memory (RAM): $(sysctl -n hw.memsize | awk '{printf "%.2f GB", $0/1024/1024/1024}')"
    echo "Available Disk Space:"
    df -h / | awk '{print $4}' | tail -1
    echo "IP Addresses:"
    ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
}

# Function to display network information
function display_network_info() {
    echo "Network Information:"
    print_line

    echo "Current Wi-Fi Network:"
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | awk -F: '/ SSID/{print $2}'
    echo "MAC Address:"
    ifconfig en0 | awk '/ether/{print $2}'
    echo "Router IP Address:"
    netstat -nr | grep default | awk '{print $2}'
}

# Main script
display_system_info
echo
display_network_info
