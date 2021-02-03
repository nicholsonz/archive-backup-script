#!/bin/bash

# Archive Backup Script

BACKUP_DIR="/mnt/backup/$(hostname)/arcvdbkp"

TODAY=$(date +"%m-%d-%Y")
DAILY_DELETE_NAME=`date +"%a-%m-%d-%Y" --date '7 days ago'`
WEEKLY_DELETE_NAME="week"`date +"%W-%Y" --date '5 weeks ago'`
MONTHLY_DELETE_NAME=`date +"%B-%Y" --date '12 months ago'`
DAY=$(date +"%a")


LOGFILE="$BACKUP_DIR/arcvdbkp.log"


backup_files="/home /etc"

if [ ! -d $BACKUP_DIR ]; then
  echo "Creating backup directory."
  mkdir $BACKUP_DIR
else
  echo "Error.  Cannot create backup dir."

fi

echo "####################################################"
echo "  Archive Backup Start! $(date)"
echo "####################################################"


echo "Backing up $backup_files to $BACKUP_DIR/$DAY-$TODAY.tgz"
echo


if [ ! -e $BACKUP_DIR/$DAY-$TODAY.tgz ]; then
        tar czp --exclude="*[Cc]ache*" --exclude="[Tt]rash" --exclude="*[Ss]team" --exclude="$BACKUP_DIR" --exclude="/home/*/Downloads" -f $BACKUP_DIR/$DAY-$TODAY.tgz $backup_files
   else
      echo "Daily backup already exists."
fi


# Monthly backups
DAY_NUM=$(date +%u)
MONTH=$(date +%B-%Y)
  if [ ! -e $BACKUP_DIR/$MONTH.tgz ]; then
     echo "Making monthly backup of $MONTH"
    cp $BACKUP_DIR/$DAY-$TODAY.tgz $BACKUP_DIR/$MONTH.tgz

  else 
     echo "No need for monthly backup at this time."  
 fi


echo 
echo "*** Delete Old Backups ***"
echo
echo "To be deleted if present:"
echo " $DAILY_DELETE_NAME"
#echo " $WEEKLY_DELETE_NAME"
echo " $MONTHLY_DELETE_NAME"
echo

# delete old backups
  if [ -e "$BACKUP_DIR/$DAILY_DELETE_NAME.tgz" ]; then
        echo "   Deleting $BACKUP_DIR/$DAILY_DELETE_NAME.tgz"
        rm -rf $BACKUP_DIR/$DAILY_DELETE_NAME.tgz
  fi

  if [ -e "$BACKUP_DIR/$MONTHLY_DELETE_NAME.tgz" ]; then
        echo "   Deleting $BACKUP_DIR/$MONTHLY_DELETE_NAME.tgz"
    rm -rf $BACKUP_DIR/$MONTHLY_DELETE_NAME.tgz
  fi

echo
echo "**************************"
echo

day_name=$(date +"%A")
echo "Cleaning up old $day_name backups"
find $BACKUP_DIR -name "$DAY*" -type f -mtime +8 -exec rm -f {} \;

echo
echo "###### Starting backup ######"
echo

        
        echo
        echo "##########  Directory Listing  ###########"
        echo

ls -lh $BACKUP_DIR/

if test -e "$BACKUP_DIR/arcvdbkp.log"; then
   	echo "$(date) Success!" >> "$BACKUP_DIR/arcvdbkp.log"    
        echo
	echo "####################################################"
	echo "  Archived Backup Completed! $(date)"
	echo "####################################################"

else
	touch "$BACKUP_DIR/arcvdbkp.log"
	echo "New log file created!"
fi

