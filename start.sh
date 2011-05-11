#!/bin/bash

DIR=`dirname $0`
. $DIR/common.sh

cd $MCDIR
screen -S minecraft -t world -d -m $SCRIPTS/run_minecraft.sh