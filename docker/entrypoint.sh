#!/bin/bash
set -euo pipefail

GAME_HOST_IP="${GAME_HOST_IP:-127.0.0.1}"
# Inside Docker, services must listen on all interfaces so published ports reach them.
BIND_IP="${BIND_IP:-0.0.0.0}"
MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-laghaimofficial}"
CLIENT_VERSION="${CLIENT_VERSION:-3034}"
EXPRATE="${EXPRATE:-100}"
PETEXPRATE="${PETEXPRATE:-40}"
LAGHAIM_MODE="${LAGHAIM_MODE:-minimal}"

CONFIG_DIR="/opt/laghaim/config"
CONFIG_FILE="${CONFIG_DIR}/config.json"
MESSENGER_CONFIG="${CONFIG_DIR}/messenger_config.json"
PACKET_CONFIG="${CONFIG_DIR}/packet_sniffing.json"

echo "==> Laghaim server starting (mode=${LAGHAIM_MODE}, client_host=${GAME_HOST_IP}, bind=${BIND_IP})"

echo "==> Waiting for MySQL at ${MYSQL_HOST}:${MYSQL_PORT}..."
for i in $(seq 1 120); do
    if nc -z "${MYSQL_HOST}" "${MYSQL_PORT}" 2>/dev/null; then
        echo "==> MySQL is up."
        break
    fi
    if [ "$i" -eq 120 ]; then
        echo "ERROR: MySQL not reachable after 120 attempts." >&2
        exit 1
    fi
    sleep 2
done

patch_file() {
    local file="$1"
    [ -f "$file" ] || return 0
    sed -i \
        -e "s/\"CLIENT_VERSION\"[[:space:]]*:[[:space:]]*[0-9]\+/\"CLIENT_VERSION\" : ${CLIENT_VERSION}/" \
        -e "s/\"EXPRATE\"[[:space:]]*:[[:space:]]*[0-9]\+/\"EXPRATE\" : ${EXPRATE}/" \
        -e "s/\"PETEXPRATE\"[[:space:]]*:[[:space:]]*[0-9]\+/\"PETEXPRATE\" : ${PETEXPRATE}/" \
        -e "s/192\.168\.56\.105/${GAME_HOST_IP}/g" \
        -e "s/\"IP\"[[:space:]]*:[[:space:]]*\"127\.0\.0\.1\"[[:space:]]*,[[:space:]]*\"PORT\"[[:space:]]*:[[:space:]]*3306/\"IP\" : \"${MYSQL_HOST}\", \"PORT\" : ${MYSQL_PORT}/g" \
        -e "s/\"PW\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"PW\" : \"${MYSQL_PASSWORD}\"/g" \
        -e "s/\"ID\"[[:space:]]*:[[:space:]]*\"root\"/\"ID\" : \"${MYSQL_USER}\"/g" \
        "$file"
}

patch_file "${CONFIG_FILE}"

if [ -x /apply-exp-rate.sh ]; then
    /apply-exp-rate.sh
fi

if [ -x /apply-drop-rate.sh ]; then
    /apply-drop-rate.sh
fi

if [ -x /apply-gem-shop-laglamia.sh ]; then
    /apply-gem-shop-laglamia.sh
fi

if [ -x /apply-phewphew-max-money.sh ]; then
    /apply-phewphew-max-money.sh
fi

# Game servers that take their listen IP from config.json (connector, helper,
# zones, battle) bind to ${GAME_HOST_IP} (127.0.0.1). This is required because a
# zone's address is used both to bind its listener AND as the address handed to
# the client on zone change ("go_world <ip> <port>") — it must be client-reachable
# (0.0.0.0 is not). Docker publishes ports onto the container's external interface
# (eth0), so we run a userspace socat bridge eth0 -> 127.0.0.1 for those ports.
#
# IMPORTANT: only loopback-bound ports are bridged. Some services (e.g. the
# Messenger on :4011) bind 0.0.0.0 themselves and are already reachable; bridging
# those would collide ("Address already in use") and take the service down, which
# breaks inter-zone coordination ("zone cannot move, try again"). The monitor runs
# continuously so slow-starting / watchdog-restarted zones get bridged too.
bridge_monitor() {
    local eth0_ip="$1"
    local ports="$(seq 4001 4036) $(seq 5001 5036)"
    while true; do
        local listening
        listening="$(ss -ltnH 2>/dev/null)"
        for p in ${ports}; do
            # server listening on loopback for this port?
            echo "${listening}" | grep -q "127\.0\.0\.1:${p} " || continue
            # bridge already present on the external interface?
            echo "${listening}" | grep -q "${eth0_ip}:${p} " && continue
            socat "TCP-LISTEN:${p},bind=${eth0_ip},fork,reuseaddr" "TCP:127.0.0.1:${p}" >/dev/null 2>&1 &
        done
        sleep 10
    done
}

start_external_bridge() {
    local eth0_ip
    eth0_ip="$(ip -4 -o addr show eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1)"
    [ -z "${eth0_ip}" ] && eth0_ip="$(hostname -i 2>/dev/null | awk '{print $1}')"
    if [ -z "${eth0_ip}" ]; then
        echo "WARN: could not detect container IP; external zone access may fail." >&2
        return 0
    fi
    echo "==> Starting external access bridge monitor: ${eth0_ip} -> 127.0.0.1 (loopback-bound ports)"
    bridge_monitor "${eth0_ip}" &
}

if [ -f "${MESSENGER_CONFIG}" ]; then
    sed -i \
        -e "s/\"127\.0\.0\.1\"/\"${MYSQL_HOST}\"/g" \
        -e "s/\"laghaimofficial\"/\"${MYSQL_PASSWORD}\"/g" \
        -e "s/\"root\"/\"${MYSQL_USER}\"/g" \
        "${MESSENGER_CONFIG}"
fi

if [ -f "${PACKET_CONFIG}" ]; then
    sed -i "s/192\.168\.56\.105/${GAME_HOST_IP}/g" "${PACKET_CONFIG}"
fi

cd /opt/laghaim

mkdir -p LogFiles log laghaim/log

hold_container() {
    echo "==> Server processes launched. Holding container open..."
    tail -F connector/rebootlog.txt laghaim/rebootlog messenger/rebootlog 2>/dev/null || sleep infinity
}

case "${LAGHAIM_MODE}" in
    full)
        echo "==> Starting full server stack (all zones)..."
        ./serverrestart.sh
        ;;
    minimal)
        echo "==> Starting minimal stack (core services + decard + start zones)..."
        ./start-minimal.sh
        ;;
    *)
        echo "ERROR: Unknown LAGHAIM_MODE='${LAGHAIM_MODE}'. Use 'minimal' or 'full'." >&2
        exit 1
        ;;
esac

# Servers launched (they daemonize via nohup/watchdog). Bring up the external
# bridge once listeners exist, then keep the container alive.
start_external_bridge
hold_container
