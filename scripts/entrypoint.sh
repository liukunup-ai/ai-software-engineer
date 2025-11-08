#!/bin/bash

# Minimal entrypoint: keep container running silently.
# Behavior:
#  - If arguments are passed: exec them directly.
#  - If no arguments: stay alive via `tail -f /dev/null`.

set -euo pipefail

if [ "$#" -gt 0 ]; then
  exec "$@"
else
  # Use tail -f /dev/null which is lightweight and common.
  exec tail -f /dev/null
fi
