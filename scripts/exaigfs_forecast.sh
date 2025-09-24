#!/bin/bash
set -x

echo "Starting $0"

cp ${USHaigfs}/set_event.sh ${DATA}

mkdir -p ${DATA}/data
mkdir -p ${DATAshared}/output

# copy data in
cpreq $COMIN/aigfs.${cycle}.ic.nc $DATA/data
ls -l $DATA/data

# run graphcast forecast
$USHaigfs/run_graphcast.py \
	-n aigfs \
	-i ${DATA}/data/aigfs.${cycle}.ic.nc \
	-o ${DATAshared}/output \
	-w $FIXaigfs \
	-l 64
export err=$?; err_chk

echo "$0 completed normally"
