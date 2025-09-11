#!/bin/bash
set -x

echo "Starting $0"

mkdir -p ${DATA}/data

# copy data in
cpreq $COMIN/aigfs.${cycle}.ic.nc $DATA/data
ls -l $DATA/data

# run graphcast forecast
$USHaigfs/run_graphcast.py \
	-n mlgfs \
	-i ${DATA}/data/aigfs.${cycle}.ic.nc \
	-o ${DATA} \
	-w $FIXaigfs \
	-l 64
export err=$?; err_chk

for fh in $( seq -f "%03g" 0 6 384 ); do
  #file=$COMOUT/aigfs.${cycle}.pres.f${fh}.grib2
  #cpfs mlgfs.${cycle}.pres.0p25.f${fh}.grib2 ${file}
  #cpfs mlgfs.${cycle}.pres.0p25.f${fh}.grib2.idx ${file}.idx
  file=aigfs.${cycle}.pres.f${fh}.grib2 
  cpfs ${file} $COMOUT
  cpfs ${file}.idx $COMOUT

  if [ "$SENDDBN" = "YES" ]; then 
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2 $job $COMOUT/${file}
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2_IDX $job $COMOUT/${file}.idx
  fi

  #file=$COMOUT/aigfs.${cycle}.sfc.f${fh}.grib2
  #cpfs mlgfs.${cycle}.sfc.0p25.f${fh}.grib2 ${file}
  #cpfs mlgfs.${cycle}.sfc.0p25.f${fh}.grib2.idx ${file}.idx
  file=aigfs.${cycle}.sfc.f${fh}.grib2
  cpfs ${file} $COMOUT
  cpfs ${file}.idx $COMOUT

  if [ "$SENDDBN" = "YES" ]; then 
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2 $job $COMOUT/${file}
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2_IDX $job $COMOUT/${file}.idx
  fi
done

echo "$0 completed normally"
