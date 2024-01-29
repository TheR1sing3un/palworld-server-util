#!/bin/bash

source ./function.sh

#################################### You should configure the following variables ####################################

# Define OSS bucket where you want to save your backup, you can change it to your own OSS bucket
OSS_BUCKET="ther1sing3un-pal-bucket"

# Define OSS directory where you want to save your backup, you can change it to your own OSS directory
OSS_DIR="pal-backup"


#################################### You don't need to change the following variables ####################################

# Set Pal Server Save directory as source directory
SOURCE_DIR="$(get_pal_server_working_dir)/Pal/Saved"

DAY=$(date +%Y%m%d)
TIME=$(date +%H%M%S)
DATE="${DAY}_${TIME}"

# After packing, the backup file name is backup_YYYYMMDD_HHMMSS.tar 
BACKUP_FILE_NAME="backup_${DATE}.tar"

# Save the backup file in tmp directory
LOCAL_FILE_PATH="tmp/${BACKUP_FILE_NAME}"

# Upload the backup file to OSS, the path is oss://$OSS_BUCKET/$OSS_DIR/$DAY/backup_YYYYMMDD_HHMMSS.tar
OSS_FILE_PATH="oss://${OSS_BUCKET}/${OSS_DIR}/${DAY}/${BACKUP_FILE_NAME}"



#################################### functions ####################################

# Check preconditions
check_preconditions() {
    # Check Pal Server exist
    if ! $(check_pal_server_exist); then
        echo "Pal Server not exist"
        return 1
    fi
    # Check ossutil exist
    if ! $(check_ossutil_exist); then
        echo "ossutil not exist"
        return 1
    fi
    # Check ossutil configured
    if ! $(check_ossutil_configured); then
        echo "ossutil not configured"
        return 1
    fi
}

# Backup
backup() {
    # Check if tmp directory exists
    if [ ! -d "tmp" ]; then
        mkdir tmp
    fi
    # Pack the directory
    sudo tar -cvf "${LOCAL_FILE_PATH}" "${SOURCE_DIR}"

    # Upload to OSS, make sure you have installed ossutil, you can refer to https://help.aliyun.com/document_detail/120075.html?spm=a2c4g.11186623.6.1208.3f7b7c3e5Z7Z8X
    ossutil cp "tmp/${BACKUP_FILE_NAME}" "${OSS_FILE_PATH}"

    echo "Sucessfully backup ${SOURCE_DIR} to ${OSS_FILE_PATH}"

    # Delete tmp directory
    sudo rm -rf tmp
}

#################################### main ####################################
main() {
    # Check preconditions
    if ! $(check_preconditions); then
        echo "Check preconditions failed, please check the error message above"
        return 1
    fi
    # Backup
    backup
}
main