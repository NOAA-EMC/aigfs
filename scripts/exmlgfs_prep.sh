#!/bin/bash
set -x

echo "Starting $0"

# copy data in
cpreq $COMINgfs/gfs.t${cyc}z.pgrb2.0p25.f000 $DATA/data/
cpreq $COMINgfs/gfs.t${cyc}z.pgrb2.0p25.f006 $DATA/data/
cpreq $COMINgfsm1/gfs.t${prev_cyc}z.pgrb2.0p25.f000 $DATA/data/
cpreq $COMINgfsm1/gfs.t${prev_cyc}z.pgrb2.0p25.f006 $DATA/data/
ls -l $DATA/data/ 

# run gfs_utility script to create graphcast input
python $USHmlgfs/gfs_utility.py "$prev_PDYHH" "$curr_PDYHH" -o output
export err=$?; err_chk

cpfs output/source-gfs_date-${curr_PDYHH}_res-0.25_levels-13_steps-3.nc $COMOUT

echo "$0 completed normally"
