#! /bin/bash

DIR=`dirname $0`
. $DIR/common.sh

PIGMAP=$APPS/pigmap/pigmap
IMG=$MCDIR/map/img
HTML=$MCDIR/map/html
OUTDIR=$MCDIR/map/pigmap

echo `date +"%F %H:%M:%S"` Starting Overviewer Map Generation

#full
#$PIGMAP -i $MAPWORLD -o $OUTDIR -g $IMG -m $HTML -B 6 -T 1 -Z 10 -h $THREADS
#incremental
nice -n $PRI $PIGMAP -i $MAPWORLD -o $OUTDIR -g $IMG -m $HTML -r $LOG/map.rsync -h $THREADS

TIME=`TZ=EST date +"%A %B %-d, %Y %X %Z"`
cp $OUTDIR/index.tpl $OUTDIR/index.html
sed -i "s/UPDATED/$TIME/g" $OUTDIR/index.html

echo `date +"%F %H:%M:%S"` Done Generating Overviewer Map

if [ `date +%k` == 0 ] ; then
    echo `date +"%F %H:%M:%S"` Finding Signs
    nice -n $PRI python $APPS/findsigns/findSigns.py $MAPWORLD $OUTDIR
    echo `date +"%F %H:%M:%S"` Done Finding Signs
fi
