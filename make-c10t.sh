#! /bin/bash

DIR=`dirname $0`
. $DIR/common.sh

C10T=$APPS/c10t/build/c10t
OUTDIR=$MCDIR/map/carto
CACHE=$MCDIR/map/cache/carto

CURTIME=`date +%Y%m%d-%H%M`

echo `date +"%F %H:%M:%S"` Generating c10t Maps

echo `date +"%F %H:%M:%S"` Generating Overhead Map
nice -n $PRI $C10T -w $MAPWORLD -o $OUTDIR/over/map-$CURTIME.png -s --cache-dir $CACHE --cache-compress --cache-key over -m $THREADS --log $LOG
echo `date +"%F %H:%M:%S"` Generating Isometric Map
nice -n $PRI $C10T -w $MAPWORLD -o $OUTDIR/iso/map-$CURTIME.png -s --cache-dir $CACHE --cache-compress --cache-key iso -m $THREADS --log $LOG -z
echo `date +"%F %H:%M:%S"` Generating Night Isometric Map
nice -n $PRI $C10T -w $MAPWORLD -o $OUTDIR/iso-night/map-$CURTIME.png -s --cache-dir $CACHE --cache-compress --cache-key iso-night -m $THREADS --log $LOG/c10t.log -z -n

echo `date +"%F %H:%M:%S"` Done Generating c10t Maps

echo `date +"%F %H:%M:%S"` Linking to Current c10t Maps

PWD=`pwd`

rm $OUTDIR/over/map-current.png
cd $OUTDIR/over/
ln -s map-$CURTIME.png map-current.png
rm $OUTDIR/iso/map-current.png
cd $OUTDIR/iso/
ln -s map-$CURTIME.png map-current.png
rm $OUTDIR/iso-night/map-current.png
cd $OUTDIR/iso-night/
ln -s map-$CURTIME.png map-current.png

cd $PWD