#!/bin/bash

################################################################
##
##   Site Backup To Amazon S3
##   Written By: YONG MOOK KIM
##   https://www.mkyong.com/linux/how-to-zip-unzip-tar-in-unix-linux/
##   https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
##
##   $crontab -e
##   Weekly website backup, at 01:30 on Sunday
##   30 1 * * 0 /home/mkyong/script/backup-site.sh > /dev/null 2>&1
################################################################

NOW=$(date +"%Y-%m-%d")
NOW_TIME=$(date +"%Y-%m-%d %T %p")
NOW_MONTH=$(date +"%Y-%m")
PROJECT="pcrondinele"
NAME_SITE="inovweb.slgplataforma.com.br"

BACKUP_DIR="/home/$USER/backup/$NOW_MONTH"
BACKUP_FILENAME="site-$NOW.tar.gz"
BACKUP_FULL_PATH="$BACKUP_DIR/$BACKUP_FILENAME"


AMAZON_S3_BUCKET="s3://backupplataformdrr/backups/$PROJECT/site/$NOW_MONTH/"
AMAZON_S3_BIN="/home/$USER/.local/bin/aws"

# put the files and folder path here for backup
CONF_FOLDERS_TO_BACKUP=("/etc/apache2/sites-available/$NAME_SITE.conf")
SITE_FOLDERS_TO_BACKUP=("/var/www/$NAME_SITE/" "/var/moodledata")

#################################################################

mkdir -p ${BACKUP_DIR}

backup_files(){
        tar -czf ${BACKUP_DIR}/${BACKUP_FILENAME} ${CONF_FOLDERS_TO_BACKUP[@]} ${SITE_FOLDERS_TO_BACKUP[@]}
}

upload_s3(){
        ${AMAZON_S3_BIN} s3 cp ${BACKUP_FULL_PATH} ${AMAZON_S3_BUCKET}
}

backup_files
upload_s3

#if [ $? -eq 0 ]; then
#  echo "Backup is done! ${NOW_TIME}" | mail -s "Backup Successful (Site) - ${NOW}" -r cron admin@mkyong.com
#else
#  echo "Backup is failed! ${NOW_TIME}" | mail -s "Backup Failed (Site) ${NOW}" -r cron admin@mkyong.com
#fi;

