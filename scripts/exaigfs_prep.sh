#!/bin/bash
set -x

echo "Starting $0"

# Wait for up to 15 minutes to find the latest GFS 6-h forecast
# gfs.t${cyc}z.pres_a.0p25.${fh}.grib2
target=$COMINgfs/gfs.t${cyc}z.pres_a.0p25.f000.grib2
n_tries=30
for counter in $( seq 1 1 $n_tries ); do
    if [[ -e "$target" ]]; then
        echo "Required file found: $target"
        sleep 30
        break
    elif [[ $counter -eq $n_tries ]]; then
        echo "Required file not found after $counter tries: $target"
        export err=1; err_chk
    fi

    sleep 30
done

# copy data in
# gfs.t${cyc}z.pres_a.0p25.${fh}.grib2
cpreq $COMINgfsm2/gfs.t${m2_cyc}z.pres_a.0p25.f006 $DATA/data/
cpreq $COMINgfsm1/gfs.t${m1_cyc}z.pres_a.0p25.f000 $DATA/data/
cpreq $COMINgfsm1/gfs.t${m1_cyc}z.pres_a.0p25.f006 $DATA/data/
cpreq $COMINgfs/gfs.t${cyc}z.pres_a.0p25.f000 $DATA/data/
ls -l $DATA/data/

# run gfs_utility script to create graphcast input
$USHaigfs/gen_aigfs_ics.py "$m2_PDYHH" "$curr_PDYHH" -o output
export err=$?; err_chk

cpfs output/aigfs.t${cyc}z.ic.nc $COMOUT

echo "$0 completed normally"
