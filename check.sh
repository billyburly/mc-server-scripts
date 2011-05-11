#!/bin/bash

DIR=`dirname $0`
. $DIR/common.sh

test=`ps a | grep -v grep | grep craftbukkit`
if [ ! "$test" ] ; then
    echo "minecraft not running, starting now"
    $SCRIPTS/start.sh
fi