#!/bin/bash
# Custom buy shops on start zone (:4005 = t_shop.a_world_num 4).
# Restores vanilla Gem Shopkeeper exchange NPCs (67/180, keeper 166).
# Shop 1871: gems (Magic Shopkeeper 94) at (6720, 5135).
# Shop 1873: magic/rune stones only — same row, 1 tile south (client ~17 slot limit).
# Shop 142: existing Machine Dealer (6729, 5129) — full gun list.
# Shop 1880: disabled (was a duplicate dealer that never matched the visible NPC).
#
# Shops are loaded once when the start zone process boots. After this script runs you
# MUST restart the laghaim container (not just re-enter the zone):
#   docker compose restart laghaim
set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-laghaimofficial}"
DATA_DB="${DATA_DB:-kor_ndev_neogeo_data}"

GEM_SHOP_IDX=1871
STONE_SHOP_IDX=1873
GUN_SHOP_IDX=142
LEGACY_GUN_SHOP_IDX=1880
GEM_SHOP_WORLD=4
GEM_SHOP_X=6720
GEM_SHOP_Z=5135
STONE_SHOP_X=6720
STONE_SHOP_Z=5143
GEM_SHOP_ITEM_BASE=139001
STONE_SHOP_ITEM_BASE=139030
GUN_SHOP_ITEM_BASE=139200
GEM_KEEPER_IDX=94
GUN_KEEPER_IDX=91

GEM_ITEM_VNUMS="215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,1067,1068"
STONE_ITEM_VNUMS="551,552,553,554"
# Steyr/Maxim/Cheytac/Beretta (10457+) are not in this client DB bundle.
GUN_ITEM_VNUMS="467,286,287,305,306,407,408,409,410,474,983,1316,644,1321,1066,2052,2176,2746"

LEGACY_EXCHANGE_SHOPS="67 180"
CHEAP_SHOP_ITEM_VNUMS="${GEM_ITEM_VNUMS},${STONE_ITEM_VNUMS},${GUN_ITEM_VNUMS}"

mysql_exec() {
    mysql -h"${MYSQL_HOST}" -P"${MYSQL_PORT}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${DATA_DB}" -N -e "$1"
}

shop_items_sql() {
    local shop_idx="$1"
    local base="$2"
    local vnums_csv="$3"
    local sql="DELETE FROM t_shopitem WHERE a_shop_idx = ${shop_idx};"
    local i=0
    local vnum
    local first=1

    IFS=',' read -r -a vnums <<< "${vnums_csv}"
    sql="${sql}
INSERT INTO t_shopitem (
  a_index, a_shop_idx, a_item_idx, a_plus_point, a_addflag, a_addflag2,
  a_endurance, a_set_time, a_count, a_price, a_enable
) VALUES"

    for vnum in "${vnums[@]}"; do
        if [ "${first}" -eq 1 ]; then
            first=0
        else
            sql="${sql},"
        fi
        sql="${sql}
  ($((base + i)), ${shop_idx}, ${vnum}, 0, 0, 0, 0, 0, 0, 1, 1)"
        i=$((i + 1))
    done
    sql="${sql};"
    printf '%s' "${sql}"
}

echo "==> Shop item prices for 1-lime buy shops (STYPE_NONE, sell_rate=1, item_price=100)..."

mysql_exec "
CREATE TABLE IF NOT EXISTS laghaim_gem_item_price_base (
  a_index INT NOT NULL PRIMARY KEY,
  base_price INT NOT NULL
) ENGINE=InnoDB;
INSERT IGNORE INTO laghaim_gem_item_price_base (a_index, base_price)
SELECT a_index, a_price FROM t_item
WHERE a_index IN (${CHEAP_SHOP_ITEM_VNUMS});
UPDATE t_item SET a_price = 100 WHERE a_index IN (${CHEAP_SHOP_ITEM_VNUMS});
"

echo "==> Restoring vanilla Gem Shopkeeper exchange NPCs (shops 67, 180)..."

for legacy_idx in ${LEGACY_EXCHANGE_SHOPS}; do
    mysql_exec "
UPDATE t_shop SET
  a_keeper_idx = 166,
  a_name = 'Gem Shopkeeper',
  a_type = 0,
  a_sell_rate = 100,
  a_enable = 1
WHERE a_index = ${legacy_idx};
DELETE FROM t_shopitem WHERE a_shop_idx = ${legacy_idx};
"
done

echo "==> Disabling duplicate gun shop ${LEGACY_GUN_SHOP_IDX}..."
mysql_exec "
UPDATE t_shop SET a_enable = 0 WHERE a_index = ${LEGACY_GUN_SHOP_IDX};
DELETE FROM t_shopitem WHERE a_shop_idx = ${LEGACY_GUN_SHOP_IDX};
"

echo "==> Buy gem shop ${GEM_SHOP_IDX} (Magic Shopkeeper) at (${GEM_SHOP_X}, ${GEM_SHOP_Z})..."

mysql_exec "
INSERT INTO t_shop (
  a_index, a_enable, a_world_num, a_name, a_keeper_idx,
  a_type, a_sell_rate, a_buy_rate, a_pos_x, a_pos_z, a_pos_r
) VALUES (
  ${GEM_SHOP_IDX}, 1, ${GEM_SHOP_WORLD}, 'Gem Merchant', ${GEM_KEEPER_IDX},
  0, 1, 30, ${GEM_SHOP_X}, ${GEM_SHOP_Z}, 90
) ON DUPLICATE KEY UPDATE
  a_enable = VALUES(a_enable),
  a_world_num = VALUES(a_world_num),
  a_name = VALUES(a_name),
  a_keeper_idx = VALUES(a_keeper_idx),
  a_type = VALUES(a_type),
  a_sell_rate = VALUES(a_sell_rate),
  a_buy_rate = VALUES(a_buy_rate),
  a_pos_x = VALUES(a_pos_x),
  a_pos_z = VALUES(a_pos_z),
  a_pos_r = VALUES(a_pos_r);

$(shop_items_sql "${GEM_SHOP_IDX}" "${GEM_SHOP_ITEM_BASE}" "${GEM_ITEM_VNUMS}")
"

gem_count="$(mysql_exec "SELECT COUNT(*) FROM t_shopitem WHERE a_shop_idx=${GEM_SHOP_IDX} AND a_enable=1")"

echo "==> Buy magic stone shop ${STONE_SHOP_IDX} (Magic Shopkeeper) at (${STONE_SHOP_X}, ${STONE_SHOP_Z})..."

mysql_exec "
INSERT INTO t_shop (
  a_index, a_enable, a_world_num, a_name, a_keeper_idx,
  a_type, a_sell_rate, a_buy_rate, a_pos_x, a_pos_z, a_pos_r
) VALUES (
  ${STONE_SHOP_IDX}, 1, ${GEM_SHOP_WORLD}, 'Magic Stone Merchant', ${GEM_KEEPER_IDX},
  0, 1, 30, ${STONE_SHOP_X}, ${STONE_SHOP_Z}, 90
) ON DUPLICATE KEY UPDATE
  a_enable = VALUES(a_enable),
  a_world_num = VALUES(a_world_num),
  a_name = VALUES(a_name),
  a_keeper_idx = VALUES(a_keeper_idx),
  a_type = VALUES(a_type),
  a_sell_rate = VALUES(a_sell_rate),
  a_buy_rate = VALUES(a_buy_rate),
  a_pos_x = VALUES(a_pos_x),
  a_pos_z = VALUES(a_pos_z),
  a_pos_r = VALUES(a_pos_r);

$(shop_items_sql "${STONE_SHOP_IDX}" "${STONE_SHOP_ITEM_BASE}" "${STONE_ITEM_VNUMS}")
"

stone_count="$(mysql_exec "SELECT COUNT(*) FROM t_shopitem WHERE a_shop_idx=${STONE_SHOP_IDX} AND a_enable=1")"

echo "==> Buy gun shop ${GUN_SHOP_IDX} (Machine Dealer at 6729, 5129)..."

mysql_exec "
UPDATE t_shop SET
  a_enable = 1,
  a_world_num = ${GEM_SHOP_WORLD},
  a_name = 'Machine Dealer',
  a_keeper_idx = ${GUN_KEEPER_IDX},
  a_type = 0,
  a_sell_rate = 1,
  a_buy_rate = 30
WHERE a_index = ${GUN_SHOP_IDX};

$(shop_items_sql "${GUN_SHOP_IDX}" "${GUN_SHOP_ITEM_BASE}" "${GUN_ITEM_VNUMS}")
"

gun_count="$(mysql_exec "SELECT COUNT(*) FROM t_shopitem WHERE a_shop_idx=${GUN_SHOP_IDX} AND a_enable=1")"

echo "==> Done:"
echo "    gem shop ${gem_count} items at (${GEM_SHOP_X},${GEM_SHOP_Z}) — Magic Shopkeeper;"
echo "    magic stone shop ${stone_count} items at (${STONE_SHOP_X},${STONE_SHOP_Z}) — Magic Shopkeeper (south of gems);"
echo "    gun shop ${gun_count} items on Machine Dealer at (6729,5129)."
echo "    (Steyr/Maxim/Cheytac/Beretta not in this DB — skipped.)"
echo "==> IMPORTANT: run 'docker compose restart laghaim' then re-enter Laglamia."
