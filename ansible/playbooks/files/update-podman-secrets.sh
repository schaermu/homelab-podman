#!/bin/bash
set -e

# run generated script and remove it afterwards
if [ -f /tmp/ensure-podman-secrets.sh ]; then
  bash /tmp/ensure-podman-secrets.sh
  rm -f /tmp/ensure-podman-secrets.sh
fi