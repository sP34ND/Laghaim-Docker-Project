#!/bin/bash
set -euo pipefail

cd /opt/laghaim

./kill.sh 2>/dev/null || true
sleep 3

cd messenger && ./start.sh && cd ..
cd connector && ./start.sh 692 1 1 1 && cd ..
cd helper && ./start.sh 612 1 1 1 && cd ..
cd packetsniffing && ./start.sh && cd ..

cd laghaim
# Zone 0 = decard (starter), Zone 4 = start (test character spawn)
nohup ./shutdownmonitoring.sh 1 0 660 decard_ch0 > /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh 1 4 660 start_ch0   > /dev/null 2>&1 &
cd ..

echo "==> Minimal stack running. Connector :4015, PacketSniffing :4018, zones decard :4001, start :4005"
