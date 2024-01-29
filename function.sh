#!/bin/bash

# Check if Pal Server exists
function check_pal_server_exist() {
    systemctl status pal-server | grep "pal-server.service" > /dev/null 2>&1
}

# Check if Pal Server is running
function check_pal_server_running() {
    systemctl status pal-server | grep "active (running)" > /dev/null 2>&1
}

# Get Pal Server working directory
function get_pal_server_working_dir() {
    find / -name PalServer | grep common
}

# Set Pal Server working directory
function set_pal_server_working_dir() {
    PAL_SERVER_WORKING_DIR=$(get_pal_server_working_dir)
    echo "PAL_SERVER_WORKING_DIR=${PAL_SERVER_WORKING_DIR}"
}

# Check if ossutil exists
function check_ossutil_exist() {
    ossutil --version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "ossutil not exist"
        return 1
    fi
}

# Check if ossutil is configured
function check_ossutil_configured() {
    ossutil ls | grep "Bucket Number" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "ossutil not configured"
        return 1
    fi
}