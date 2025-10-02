#!/bin/bash
set -x

# =========================================================
# set_event.sh
# ------------
# Set an event to release an ecFlow task corresponding to a 
# forecast lead time.
#
# Parameters
# ----------
# fhour : str
#   Zero-padded forecast hour lead time as HHH 
# =========================================================

fhour=$1

ecflow_client --force=set ${ECF_NAME}:release_f${fhour}
