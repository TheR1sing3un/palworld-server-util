#!/bin/bash

CURRENT_DIR=$(cd "$(dirname "$0")"; pwd)

source ${CURRENT_DIR}/function.sh

# Install Pal Server
install_pal_server() {
    wget -O - https://pal.pet/pal-server/Ubuntu/install.sh | sh
}


# Install ossutil
install_ossutil() {
    curl https://gosspublic.alicdn.com/ossutil/install.sh | sudo bash
}

# Configure ossutil
configure_ossutil() {
    ossutil config
}

# Check if crontab exists
check_cron_job_exist() {
    crontab -l | grep "backup" > /dev/null 2>&1
}

# Add crontab job, default is backup every hour 
add_cron_job() {
    crontab -l > mycron
    echo "0 * * * * ${CURRENT_DIR}/backup.sh >> ${CUURENT_DIR}/backup.log" >> mycron
    crontab mycron
    rm mycron
}

main() {
    # Check Pal Server exist
    if ! check_pal_server_exist; then
        echo "Pal Server not exist"
        # Install Pal Server
        install_pal_server
        echo "Successfully install Pal Server"
    fi
    # Check Pal Server running
    if ! check_pal_server_running; then
        echo "Pal Server not running"
        # Start Pal Server
        systemctl start pal-server
        echo "Successfully start Pal Server"
    fi
    # Check ossutil exist
    if ! check_ossutil_exist; then
        echo "ossutil not exist"
        # Install ossutil
        install_ossutil
        echo "Successfully install ossutil"
    fi
    # Check ossutil configured
    if ! check_ossutil_configured; then
        echo "ossutil not configured"
        # Configure ossutil
        configure_ossutil
        echo "Successfully configure ossutil"
    fi
    # Check if backup cron job exist
    if ! check_cron_job_exist; then
        echo "backup cron job not exist"
        # Add backup cron job
        add_cron_job
        echo "Successfully add backup cron job"
    fi
    echo "Celebrate! You have successfully installed Pal Server Backup Tool!"
}

main