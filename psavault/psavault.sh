#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
source /opt/psautomate/menu/functions/functions.sh
source /opt/psapress/psavault/psavault.func

file="/var/psautomate/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" > /var/psautomate/restore.id
fi

initial
apprecall
primaryinterface
