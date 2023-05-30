#!/usr/bin/env bash

# Install pip packages to a temporary directory where we definitely have write access.
INSTALL_DIR="$(mktemp -d)"
export PYTHONPATH="${INSTALL_DIR}:${PYTHONPATH}"

/opt/conda/envs/py3.11/bin/python -m pip install --target "$INSTALL_DIR" .
/opt/conda/envs/py3.11/bin/python -m PyInstaller "$@"

rm -r "$INSTALL_DIR"
