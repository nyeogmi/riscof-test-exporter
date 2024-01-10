#!/usr/bin/env bash
# This script should be run inside the vagrant machine, as root
set -euxo pipefail

# clean up our destination
rm -rf /project/outbox/*

# run the tests
source /project/workspace/venv/bin/activate
mkdir -p /project/workspace/testing
cd /project/workspace/testing
rm -rf riscof_work
riscof validateyaml --config=/project/devices/config.ini
riscof run --config=/project/devices/config.ini --suite=/project/workspace/riscv-arch-test/riscv-test-suite/ --env=/project/workspace/riscv-arch-test/riscv-test-suite/env --no-ref-run
cp -r riscof_work/* /project/outbox/