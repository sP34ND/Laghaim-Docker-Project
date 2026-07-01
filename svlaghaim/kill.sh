#/bin/bash
chmod -R 755 *
killall -15 shutdownmonitoring.sh
killall -15 LhDebug

killall -15 Connector
killall -15 Messenger
killall -15 Helper
killall -15 PacketSniffing
