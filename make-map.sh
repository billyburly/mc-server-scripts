#! /bin/bash

DIR=`dirname $0`
. $DIR/common.sh

DATA=$MCDIR/map

echo `date +"%F %H:%M:%S"` Starting Map Creation

#force save world & disable saving
screen -S minecraft -p world -X stuff "save-off"`echo -ne '\015'`
screen -S minecraft -p world -X stuff "save-all"`echo -ne '\015'`
sleep 20

#take snapshot of world
echo `date +"%F %H:%M:%S"` Taking Snapshot of World
rsync -av $WORLD $DATA > $LOG/map.rsync

#turn on saving
screen -S minecraft -p world -X stuff "save-on"`echo -ne '\015'`

#if [ `date +%k` == 0 ] ; then
#    $MCDIR/scripts/make-c10t.sh
#fi

#generate overviewer map
$MCDIR/scripts/make-pigmap.sh