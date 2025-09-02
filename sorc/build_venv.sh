#!/bin/bash

set -eux

readonly HOMEmlgfs=$(cd $(dirname $(readlink -f -n "${BASH_SOURCE[0]}"))/.. && pwd -P)

venv_req="${HOMEmlgfs}/sorc/requirements.txt"

set +x
# TODO: Make this work for non-WCOSS platforms
module reset
module load "PrgEnv-intel/${PrgEnv_intel_ver:-8.3.3}"
module load "intel/${intel_ver:-19.1.3.304}"
module load "python/${python_ver:-3.12.0}"
module load "g2c/${g2c_ver:-2.2.0}"
module list
set -x

# Needed for grib2io
export G2C_DIR="${g2c_ROOT}"
# g2C installed modulefile from spack-stack prepends to LD_LIBRARY_PATH.  TODO: Remove
LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${g2c_ROOT}/lib64"
export LD_LIBRARY_PATH

# Target venv path
venv_dir="${HOMEmlgfs}/venv"
rm -rf "${venv_dir}"

# Needed for WCOSS (TMPDIR is not writable for users)
# Does not hurt for other platforms, but is unnecesary elsewhere
export TMPDIR="${venv_dir}/tmpdir"
rm -rf "${TMPDIR}"
mkdir -p "${TMPDIR}"

# Start creating the venv
python3 -m virtualenv "${venv_dir}"
source "${venv_dir}/bin/activate"
pip install -r "${venv_req}"
pip list
