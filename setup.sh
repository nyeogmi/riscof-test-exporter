#!/usr/bin/env bash
set -euxo pipefail

cd /project
mkdir -p workspace

apt-get update
apt-get install python3.8 python3-pip python3.8-venv -y

# Everything we do with Python is locked down into ~/venv
python3.8 -m venv workspace/venv
source workspace/venv/bin/activate
python3.8 -m pip install -r riscof-test-exporter/requirements.txt

# Troubleshooting step for Savannah.gnu.org:
# Recommended here: https://savannah.gnu.org/maintenance/SavannahTLSInfo
sed --in-place '/DST_Root_CA_X3.crt/s/^/!/' /etc/ca-certificates.conf
update-ca-certificates

# Install the 32-bit RISCV-GNU toolchain
cd workspace
apt-get install autoconf automake autotools-dev curl python3 libmpc-dev \
  libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
  patchutils bc zlib1g-dev libexpat-dev -y
git -C riscv-gnu-toolchain pull || git clone --recursive https://github.com/riscv/riscv-gnu-toolchain  # Note: this is 6GiB!
git -C riscv-opcodes pull || git clone --recursive https://github.com/riscv/riscv-opcodes
cd riscv-gnu-toolchain
./configure --prefix=/usr --with-arch=rv32gc --with-abi=ilp32d 
make
cd ../
cd ../

# Install Spike, a reference model
cd workspace
apt-get install device-tree-compiler
cd riscv-gnu-toolchain
cd spike
mkdir -p build
cd build
../configure --prefix=/usr
make install
cd ../../../../

# Remember Riscof? We set up its virtual environment earlier
# We're still in that environment
# Get a copy of the tests
cd workspace
git -C riscv-arch-test status || riscof --verbose info arch-test --clone
cd ../