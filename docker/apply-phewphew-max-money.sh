#!/bin/bash
# Dev grants for PhewPhew: max lime + max LP (cap 2100000000 per server source).
# Applied at container start while offline; fully log out and back in to pick up.
set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-laghaimofficial}"
CHAR_DB="${CHAR_DB:-kor_ndev_neogeo_char}"
EVENT_DB="${EVENT_DB:-kor_ndev_neogeo_event}"
CHAR_NAME="${PHEWPHEW_CHAR_NAME:-PhewPhew}"
MAX_VALUE=2100000000

mysql_exec() {
    local db="$1"
    shift
    mysql -h"${MYSQL_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${db}" -N -e "$*"
}

user_index="$(mysql_exec "${CHAR_DB}" "SELECT a_user_index FROM t_characters WHERE a_name = '${CHAR_NAME}' LIMIT 1")"
if [ -z "${user_index}" ]; then
    echo "WARN: character '${CHAR_NAME}' not found — skipping." >&2
    exit 0
fi

echo "==> Setting ${CHAR_NAME} (user ${user_index}) money to ${MAX_VALUE}..."

mysql_exec "${CHAR_DB}" "
UPDATE t_characters
SET a_money = ${MAX_VALUE}
WHERE a_name = '${CHAR_NAME}';
"

echo "==> Setting account LP to ${MAX_VALUE} in ${EVENT_DB}.TBL_LaghaimPointUser..."

mysql_exec "${EVENT_DB}" "
INSERT INTO TBL_LaghaimPointUser (lpu_user_idx, lpu_user_lag_idx, lpu_user_idname, lpu_user_lag_point, lpu_update_date)
SELECT c.a_user_index, 0, COALESCE(u.a_2p4p_user_id, '${CHAR_NAME}'), ${MAX_VALUE}, NOW()
FROM ${CHAR_DB}.t_characters c
LEFT JOIN kor_ndev_neogeo_user.t_users u ON u.a_index = c.a_user_index
WHERE c.a_name = '${CHAR_NAME}'
ON DUPLICATE KEY UPDATE
  lpu_user_lag_point = ${MAX_VALUE},
  lpu_update_date = NOW();
"

money="$(mysql_exec "${CHAR_DB}" "SELECT a_money FROM t_characters WHERE a_name = '${CHAR_NAME}' LIMIT 1")"
lp="$(mysql_exec "${EVENT_DB}" "SELECT lpu_user_lag_point FROM TBL_LaghaimPointUser WHERE lpu_user_idx = ${user_index} LIMIT 1")"

echo "==> ${CHAR_NAME} a_money = ${money}, LP = ${lp}"
echo "==> Fully log out to character select, then log back in (or use sp_money / sp_lp while online)."

