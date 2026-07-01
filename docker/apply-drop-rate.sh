#!/bin/bash
# Applies drop multipliers to:
#   - t_npc.a_item_percent_*     (per-monster loot, roll 0..10000)
#   - t_zone_itemrate.a_zone*    (zone-wide loot on any kill, roll 0..1000000)
#   - t_npc_drop_item.a_itemrate (group drop tables, roll 0..1000000)
#
# DROPRATE        — misc/consumable/material mob + group drops
# EQUIP_DROPRATE  — wear/armor/weapon/sub equipment (guns, demolition, cannon MK1, …)
# ZONE_DROPRATE   — zone-wide kill rolls (usually lower than mob drops)
set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-laghaimofficial}"
DATA_DB="${DATA_DB:-kor_ndev_neogeo_data}"
DROPRATE="${DROPRATE:-10}"
ZONE_DROPRATE="${ZONE_DROPRATE:-10}"
EQUIP_DROPRATE="${EQUIP_DROPRATE:-100}"
ZONE_DICE_MAX=1000000
NPC_DICE_MAX=10000
# ITYPE_WEAR=0, ITYPE_ARMOR=1, ITYPE_WEAPON=2, ITYPE_SUB=5 (demolition, cannon MK1, …)
EQUIP_TYPE_SQL="0, 1, 2, 5"

for var_name in DROPRATE ZONE_DROPRATE EQUIP_DROPRATE; do
    var_value="${!var_name}"
    if ! [[ "${var_value}" =~ ^[0-9]+$ ]] || [ "${var_value}" -lt 1 ]; then
        echo "ERROR: ${var_name} must be a positive integer (got '${var_value}')." >&2
        exit 1
    fi
done

mysql_exec() {
    mysql -h"${MYSQL_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${DATA_DB}" -N -e "$1"
}

zone_set_clause=""
zone_base_cols=""
zone_insert_cols="a_index"
zone_insert_select="a_index"
for z in $(seq 0 25); do
    zone_set_clause="${zone_set_clause}
  n.a_zone${z} = LEAST(${ZONE_DICE_MAX}, b.z${z} * ${ZONE_DROPRATE}),"
    zone_base_cols="${zone_base_cols} z${z} INT NOT NULL DEFAULT 0,"
    zone_insert_cols="${zone_insert_cols}, z${z}"
    zone_insert_select="${zone_insert_select}, a_zone${z}"
done
zone_set_clause="${zone_set_clause%,}"
zone_base_cols="${zone_base_cols%,}"

npc_item_joins=""
npc_set_clause=""
for s in $(seq 0 9); do
    npc_item_joins="${npc_item_joins}
LEFT JOIN t_item it${s} ON it${s}.a_index = n.a_item_${s}"
    npc_set_clause="${npc_set_clause}
  n.a_item_percent_${s} = LEAST(${NPC_DICE_MAX}, b.p${s} * IF(it${s}.a_type_idx IN (${EQUIP_TYPE_SQL}), ${EQUIP_DROPRATE}, ${DROPRATE})),"
done
npc_set_clause="${npc_set_clause%,}"

echo "==> Applying drop multipliers: DROPRATE=${DROPRATE}x (misc), EQUIP_DROPRATE=${EQUIP_DROPRATE}x (equipment), ZONE_DROPRATE=${ZONE_DROPRATE}x (zone-wide)..."

mysql_exec "
CREATE TABLE IF NOT EXISTS laghaim_npc_drop_base (
  a_index INT NOT NULL PRIMARY KEY,
  p0 INT NOT NULL DEFAULT 0,
  p1 INT NOT NULL DEFAULT 0,
  p2 INT NOT NULL DEFAULT 0,
  p3 INT NOT NULL DEFAULT 0,
  p4 INT NOT NULL DEFAULT 0,
  p5 INT NOT NULL DEFAULT 0,
  p6 INT NOT NULL DEFAULT 0,
  p7 INT NOT NULL DEFAULT 0,
  p8 INT NOT NULL DEFAULT 0,
  p9 INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

INSERT IGNORE INTO laghaim_npc_drop_base (
  a_index, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9
)
SELECT
  a_index,
  a_item_percent_0, a_item_percent_1, a_item_percent_2, a_item_percent_3, a_item_percent_4,
  a_item_percent_5, a_item_percent_6, a_item_percent_7, a_item_percent_8, a_item_percent_9
FROM t_npc;

UPDATE t_npc n
INNER JOIN laghaim_npc_drop_base b ON n.a_index = b.a_index
${npc_item_joins}
SET
${npc_set_clause};

CREATE TABLE IF NOT EXISTS laghaim_zone_itemrate_base (
  a_index INT NOT NULL PRIMARY KEY,
  ${zone_base_cols}
) ENGINE=InnoDB;

INSERT IGNORE INTO laghaim_zone_itemrate_base (${zone_insert_cols})
SELECT ${zone_insert_select}
FROM t_zone_itemrate;

UPDATE t_zone_itemrate n
INNER JOIN laghaim_zone_itemrate_base b ON n.a_index = b.a_index
SET
${zone_set_clause};

CREATE TABLE IF NOT EXISTS laghaim_npc_drop_item_base (
  a_groupnum INT NOT NULL,
  a_pcroom TINYINT NOT NULL,
  a_itemindex INT NOT NULL,
  base_rate INT NOT NULL,
  PRIMARY KEY (a_groupnum, a_pcroom, a_itemindex)
) ENGINE=InnoDB;

INSERT IGNORE INTO laghaim_npc_drop_item_base (a_groupnum, a_pcroom, a_itemindex, base_rate)
SELECT a_groupnum, a_pcroom, a_itemindex, a_itemrate
FROM t_npc_drop_item;

UPDATE t_npc_drop_item n
INNER JOIN laghaim_npc_drop_item_base b
  ON n.a_groupnum = b.a_groupnum AND n.a_pcroom = b.a_pcroom AND n.a_itemindex = b.a_itemindex
LEFT JOIN t_item it ON it.a_index = n.a_itemindex
SET n.a_itemrate = LEAST(
  ${ZONE_DICE_MAX},
  b.base_rate * IF(it.a_type_idx IN (${EQUIP_TYPE_SQL}), ${EQUIP_DROPRATE}, ${DROPRATE})
);
"

npc_sample="$(mysql_exec "SELECT CONCAT('npc:', a_index, ':', a_item_percent_0) FROM t_npc WHERE a_index IN (532, 541) ORDER BY a_index")"
zone_sample="$(mysql_exec "SELECT CONCAT('world6-rate3:', a_zone6) FROM t_zone_itemrate WHERE a_index=3")"
equip_sample="$(mysql_exec "SELECT CONCAT('gun55:', n.a_item_percent_2) FROM t_npc n WHERE n.a_index=26 AND n.a_item_2=55")"
echo "==> Sample per-monster drops: ${npc_sample}"
echo "==> Sample zone-wide rate (world 6 / Wolf Wing area, profile 3): ${zone_sample}"
echo "==> Sample equipment slot (Hell Cobra slot2 Air Gun): ${equip_sample}"
