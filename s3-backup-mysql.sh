#!/usr/bin/env bash
 
#########################################################################
#########################################################################
###
####       Author: Rahul Kumar
#####      Website: https://tecadmin.net
####
#########################################################################
#########################################################################
 
# Set the folder name formate with date (2022-05-28)
DATE_FORMAT=$(date +"%Y-%m-%d")
 
# MySQL server credentials
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="backup"
MYSQL_PASSWORD="password"
 
# Path to local backup directory
LOCAL_BACKUP_DIR="/home/rondinelle/backup"
 
# Set s3 bucket name and directory path
S3_BUCKET_NAME="backupplataformdrr"
S3_BUCKET_PATH="backups/pcrodinelle/backup-db"
 
# Number of days to store local backup files
BACKUP_RETAIN_DAYS=30 
 
# Use a single database or space separated database's names
DATABASES="teste"
 
##### Do not change below this line
 
mkdir -p ${LOCAL_BACKUP_DIR}/${DATE_FORMAT}
 
LOCAL_DIR=${LOCAL_BACKUP_DIR}/${DATE_FORMAT}
REMOTE_DIR=s3://${S3_BUCKET_NAME}/${S3_BUCKET_PATH}
 
for db in $DATABASES; do
   mysqldump --no-tablespaces \
        -h ${MYSQL_HOST} \
        -P ${MYSQL_PORT} \
        -u ${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        --single-transaction ${db} | gzip -9 > ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz
 
        aws s3 cp ${LOCAL_DIR}/${db}-${DATE_FORMAT}.sql.gz ${REMOTE_DIR}/${DATE_FORMAT}/
done
 
DBDELDATE=`date +"${DATE_FORMAT}" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${LOCAL_BACKUP_DIR} ]; then
 cd ${LOCAL_BACKUP_DIR}
 if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
 rm -rf ${DBDELDATE}
 
 fi
fi
## Script ends here
