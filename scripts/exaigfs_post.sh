#!/bin/bash
set -x

echo "Starting $0"

for prod in pres sfc; do
  file=aigfs.${cycle}.${prod}.f${fh}.grib2
  
  echo "[$(date)]: Opening GRIB2 file"
  wgrib2 -s ${DATAshared}/output/${file} > ${DATAshared}/output/${file}.idx
  export err=$?; err_chk
  echo "[$(date)]: Index file created successfully"

  cpfs ${DATAshared}/output/${file} ${COMOUT}
  cpfs ${DATAshared}/output/${file}.idx ${COMOUT}

  if [ "$SENDDBN" = "YES" ]; then 
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2 $job $COMOUT/${file}
    $DBNROOT/bin/dbn_alert MODEL AIGFS_GB2_IDX $job $COMOUT/${file}.idx
  fi
done

echo "$0 completed normally"
