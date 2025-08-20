#!/bin/bash
set -x

echo "Starting $0"

mkdir -p ${DATA}/data

# copy data in
cpreq $COMIN/source-gfs_date-${curr_PDYHH}_res-0.25_levels-13_steps-3.nc $DATA/data
ls -l $DATA/data

# run graphcast forecast
python $USHmlgfs/run_graphcast.py \
	-i ${DATA}/data/source-gfs_date-"$curr_PDYHH"_res-0.25_levels-13_steps-3.nc \
	-o ${DATA} \
	-w $FIXmlgfs \
	-l 64 \
	-m grib2io
export err=$?; err_chk

for fh in $( seq -f "%03g" 0 6 384 ); do
  cpfs forecasts_13_levels/graphcastgfs.${cycle}.pgrb2.0p25.f${fh} $COMOUT
  cpfs forecasts_13_levels/graphcastgfs.${cycle}.pgrb2.0p25.f${fh}.idx $COMOUT
done

echo "$0 completed normally"
