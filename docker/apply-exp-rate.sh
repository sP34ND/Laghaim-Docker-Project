#!/bin/bash
# This server build ignores config.json EXPRATE — monster exp is read from
# kor_ndev_neogeo_data.t_npc.a_exp at zone startup. Apply the multiplier here.
set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-laghaimofficial}"
DATA_DB="${DATA_DB:-kor_ndev_neogeo_data}"
EXPRATE="${EXPRATE:-100}"

if ! [[ "${EXPRATE}" =~ ^[0-9]+$ ]] || [ "${EXPRATE}" -lt 1 ]; then
    echo "ERROR: EXPRATE must be a positive integer (got '${EXPRATE}')." >&2
    exit 1
fi

mysql_exec() {
    mysql -h"${MYSQL_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${DATA_DB}" -N -e "$1"
}

echo "==> Applying monster EXP multiplier EXPRATE=${EXPRATE}x to ${DATA_DB}.t_npc..."

mysql_exec "
CREATE TABLE IF NOT EXISTS laghaim_npc_exp_base (
  a_index INT NOT NULL PRIMARY KEY,
  base_exp BIGINT NOT NULL
) ENGINE=InnoDB;

INSERT IGNORE INTO laghaim_npc_exp_base (a_index, base_exp)
SELECT a_index, a_exp FROM t_npc;

UPDATE t_npc n
INNER JOIN laghaim_npc_exp_base b ON n.a_index = b.a_index
SET n.a_exp = GREATEST(1, b.base_exp * ${EXPRATE});
"

sample="$(mysql_exec "SELECT CONCAT(a_index, ':', a_exp) FROM t_npc WHERE a_index IN (532, 541) ORDER BY a_index")"
echo "==> Sample Pharos mobs after apply: ${sample}"
