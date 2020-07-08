#!/bin/bash
set -e

echo "fixing venv"
pwd

# this makes sure the virtualenv is repaired to point to the correct paths
# before running whatever python commands in the allocation
/usr/local/bin/virtualenv-tools --update-path auto ./local/rel/.venv
ln -sf /usr/bin/python3 ./local/rel/.venv/bin/python3
ln -sf /usr/bin/python3 ./local/rel/.venv/bin/python

exec "./local/$@"
