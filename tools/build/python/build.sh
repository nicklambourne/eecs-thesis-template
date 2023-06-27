#!/usr/bin/env bash

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel)/tools/build/python"

pip-compile -o "${ROOT}/requirements.txt" "${ROOT}/requirements.in"