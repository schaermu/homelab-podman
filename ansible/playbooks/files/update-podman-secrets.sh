#!/bin/bash
set -e

# run generated script and remove it afterwards
if [ -f /tmp/ensure-podman-secrets.sh ]; then
  /bin/su -s /bin/bash -c "/bin/bash /tmp/ensure-podman-secrets.sh" - podman-user
  rm -f /tmp/ensure-podman-secrets.sh
fi