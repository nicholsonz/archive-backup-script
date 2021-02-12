#!/bin/bash

# Archive Backup Script

BACKUP_DIR="/mnt/backup/$(hostname)/arcvdbkp"
TODAY=$(date +"%a-%m-%d-%Y")
LOGFILE="$BACKUP_DIR/arcvdbkp.log"
BACKUP_FILES="/home /etc"

if [ -d $BACKUP_DIR ]; then
  echo "Backup directory exists... Backing up dirs/files now."
 elif [ ! -d $BACKUP_DIR ]; then
  echo "Creating backup directory."
  mkdir $BACKUP_DIR
else
  echo "Error!  Cannot create backup dir. Check dir permissions or backup drive availability."

fi

echo "####################################################"
echo "  Archive Backup Start! $(date)"
echo "####################################################"


echo "Backing up $BACKUP_FILES to $BACKUP_DIR/$TODAY.tgz"
echo


if [ ! -e $BACKUP_DIR/$TODAY.tgz ]; then
        tar czp --exclude="*[Cc]ache*" --exclude="[Tt]rash" --exclude="*[Ss]team" --exclude="$BACKUP_DIR" --exclude="/home/*/Downloads" -f $BACKUP_DIR/$TODAY.tgz $BACKUP_FILES  
    else
      echo "Daily backup already exists."
fi


# Monthly backups
DAY_NUM=$(date +%u)
MONTH=$(date +%B-%Y)
  if [ ! -e $BACKUP_DIR/$MONTH.tgz ]; then
     echo "Making monthly backup of $MONTH"
    cp $BACKUP_DIR/$TODAY.tgz $BACKUP_DIR/$MONTH.tgz

  else 
     echo "No need for monthly backup at this time."  
 fi


echo 
echo "*** Delete Aging Backups ***"
echo "****************************"
echo

WKOLD_DAY=$(date +"%a-%m-%d-%Y" --date="last week")
find $BACKUP_DIR -type f -name "$WKOLD_DAY*.tgz" | while read fname; do
  echo "Deleting $fname..."
  rm -rf "$fname"
done

YROLD_MNTH=$(date +%B-%Y --date="last year")
find $BACKUP_DIR -type f -name "$YROLD_MNTH*.tgz" | while read fname; do
  echo "Deleting $fname..."
  rm -rf "$fname"
done

echo
echo "*** Finished Removing Aged Backups ***"  
echo "**************************************"
echo
        
echo
echo "##########  Directory Listing  ###########"
echo

ls -lh $BACKUP_DIR/

if test -e "$BACKUP_DIR/arcvdbkp.log"; then
 echo "$(date) Success!" >> "$BACKUP_DIR/arcvdbkp.log"    
 echo
 echo "####################################################"
 echo "    Archived Backup Completed! $(date)"
 echo "####################################################" 

else
	touch "$BACKUP_DIR/arcvdbkp.log"
	echo "New log file created!"
fi
