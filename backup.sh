#! /bin/bash

DIR=`dirname $0`
. $DIR/common.sh

BACKUP=$MCDIR/backup
TEMP=$BACKUP/temp
BACKUP_USER=username
BACKUP_KEY=$BACKUP/key/id_rsa
BACKUP_HOST=hostname
BACKUP_DIR=directory

PWD=`pwd`

echo `date +"%F %H:%M:%S"` Starting Backup

screen -S minecraft -X stuff "say Backing Up World in 10 seconds"`echo -ne '\015'`
sleep 10

#force save world & disable saving
screen -S minecraft -p world -X stuff "say Backing Up World"`echo -ne '\015'`
screen -S minecraft -p world -X stuff "save-off"`echo -ne '\015'`
screen -S minecraft -p world -X stuff "save-all"`echo -ne '\015'`
sleep 20

#copy world to temp location
THEDATE=`date +%Y%m%d-%H%M`
echo `date +"%F %H:%M:%S"` Starting Copy
cp -a $WORLD $TEMP/world
cp -r $MCDIR/plugins $TEMP/plugins
cp $MCDIR/*.properties $TEMP/.
cp $MCDIR/*.txt $TEMP/.
echo `date +"%F %H:%M:%S"` Done with Copy

screen -S minecraft -p world -X stuff "save-on"`echo -ne '\015'`

#compress backup
echo `date +"%F %H:%M:%S"` Starting Tar
cd $TEMP
nice -n $PRI tar jhcf world-$THEDATE.tar.bz2 world/ *.properties
cd $PWD
echo `date +"%F %H:%M:%S"` Done with Tar

#place backup in proper folders
echo `date +"%F %H:%M:%S"` Copying Backup to proper location
cp $TEMP/world-$THEDATE.tar.bz2 $BACKUP/hourly

if [ `date +%k` == 0 ] ; then
  cp $TEMP/world-$THEDATE.tar.bz2 $BACKUP/daily

  if [ `date +%w` == 0 ] ; then
    cp $TEMP/world-$THEDATE.tar.bz2 $BACKUP/weekly
  fi

  if [ `date +%-d` == 1 ] ; then
    cp $TEMP/world-$THEDATE.tar.bz2 $BACKUP/monthly
  fi

fi
echo `date +"%F %H:%M:%S"` Done Copying

#clean up temp files
echo `date +"%F %H:%M:%S"` Cleaning Up Temp Files
rm -rf $TEMP/world/
rm -rf $TEMP/plugins/
rm $TEMP/world-$THEDATE.tar.bz2

#remove old backups
echo `date +"%F %H:%M:%S"` Cleaning Up Old backups
find $BACKUP/hourly -type f -mtime +2 -exec rm -f '{}' \;
if [ `date +%k` == 0 ] ; then
  find $BACKUP/daily -type f -mtime +7 -exec rm -f '{}' \;
  if [ `date +%w` == 0 ] ; then
    find $BACKUP/weekly -type f -mtime +45 -exec rm -f '{}' \;
  fi
fi

#copy backups to remote location
if [ `date +%k` == 0 ] ; then
  echo `date +"%F %H:%M:%S"` Copying Backups to Remote Location via rsync
  rsync -e "ssh -i $BACKUP_KEY" -a $BACKUP/{daily,monthly,weekly} $BACKUP_USER@$BACKUP_HOST:$BACKUP_DIR
fi

echo `date +"%F %H:%M:%S"` Done