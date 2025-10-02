#!/bin/bash

set -eux

readonly HOMEaigfs=$(cd $(dirname $(readlink -f -n "${BASH_SOURCE[0]}"))/.. && pwd -P)

source ../versions/build.ver
set +x
# TODO: Make this work for non-WCOSS platforms
module reset
module load "PrgEnv-intel/${PrgEnv_intel_ver:?}"
module load "intel/${intel_ver:?}"
module load "python/${python_ver:?}"
module load "g2c/${g2c_ver:?}"
module list
set -x

# Needed for grib2io
export G2C_DIR="${g2c_ROOT}"
# g2C installed modulefile from spack-stack prepends to LD_LIBRARY_PATH.  TODO: Remove
LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${g2c_ROOT}/lib64"
export LD_LIBRARY_PATH

# Target venv path
venv_dir="${HOMEaigfs}/venv"
rm -rf "${venv_dir}"

# Needed for WCOSS (TMPDIR is not writable for users)
# Does not hurt for other platforms, but is unnecesary elsewhere
export TMPDIR="${venv_dir}/tmpdir"
rm -rf "${TMPDIR}"
mkdir -p "${TMPDIR}"

# Start creating the venv
#python3 -m virtualenv --relocatable "${venv_dir}" # virtualenv version < 20.0
python3 -m virtualenv "${venv_dir}"
source "${venv_dir}/bin/activate"

# Prepare the venv requirements.txt file and save it in venv
rm -f "${venv_dir}/requirements.txt"
sed "s|{{ HOMEaigfs }}|${HOMEaigfs}|g" "${HOMEaigfs}/sorc/requirements.txt.j2" > "${venv_dir}/requirements.txt"

# modify venv/bin/activate to remove hard-coded path and use $HOMEaigfs
sed -i 's|^VIRTUAL_ENV=.*|VIRTUAL_ENV="$HOMEaigfs/venv"|' ${venv_dir}/bin/activate

pip install -r "${venv_dir}/requirements.txt"
pip list
