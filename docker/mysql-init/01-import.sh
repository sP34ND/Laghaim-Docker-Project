#!/bin/bash
set -euo pipefail

SQL_DIR="/sql"
ROOT_PW="${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD is required}"

import_db() {
    local db="$1"
    local file="$2"
    if [ ! -f "${SQL_DIR}/${file}" ]; then
        echo "ERROR: missing ${SQL_DIR}/${file}" >&2
        exit 1
    fi
    echo "==> Importing ${file} into ${db}..."
    mysql --binary-mode=1 -uroot -p"${ROOT_PW}" "${db}" < "${SQL_DIR}/${file}"
}

import_db kor_ndev_neogeo_user  kor_ndev_neogeo_userfinal.sql
import_db kor_ndev_neogeo_char  kor_ndev_neogeo_charfinal.sql
import_db kor_ndev_neogeo_data  kor_ndev_neogeo_datafinal.sql
import_db kor_ndev_neogeo_event kor_ndev_neogeo_eventfinal.sql
import_db neogeo_web            neogeo_webfinal.sql

echo "==> All Laghaim databases imported."

# Normalize the test account so the login server accepts testreg / secret.
# The connector authenticates with: WHERE passwd = PASSWORD('secret') AND pw_gubun = 1.
echo "==> Normalizing test account login (testreg / secret)..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_user -e \
    "UPDATE bg_user SET passwd = PASSWORD('secret'), pw_gubun = 1, chk_service = 'Y' WHERE user_id = 'testreg';"

echo "==> Test account ready."

# SKILL_MAX_COUNT is 156; stored as "0 " per skill (~312 chars). char(255) in the
# 2017 dump is too small and makes new character INSERT fail.
echo "==> Patching t_characters.a_skill_level column width..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_char -e \
    "SET SESSION sql_mode=''; ALTER TABLE t_characters MODIFY a_skill_level VARCHAR(1024) NOT NULL;"

echo "==> Seeding monster EXP baseline (for EXPRATE multiplier)..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_data -e \
    "CREATE TABLE IF NOT EXISTS laghaim_npc_exp_base (
       a_index INT NOT NULL PRIMARY KEY,
       base_exp BIGINT NOT NULL
     ) ENGINE=InnoDB;
     INSERT IGNORE INTO laghaim_npc_exp_base (a_index, base_exp)
     SELECT a_index, a_exp FROM t_npc;"

echo "==> Seeding monster drop baseline (for DROPRATE multiplier)..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_data -e \
    "CREATE TABLE IF NOT EXISTS laghaim_npc_drop_base (
       a_index INT NOT NULL PRIMARY KEY,
       p0 INT NOT NULL DEFAULT 0, p1 INT NOT NULL DEFAULT 0, p2 INT NOT NULL DEFAULT 0,
       p3 INT NOT NULL DEFAULT 0, p4 INT NOT NULL DEFAULT 0, p5 INT NOT NULL DEFAULT 0,
       p6 INT NOT NULL DEFAULT 0, p7 INT NOT NULL DEFAULT 0, p8 INT NOT NULL DEFAULT 0,
       p9 INT NOT NULL DEFAULT 0
     ) ENGINE=InnoDB;
     INSERT IGNORE INTO laghaim_npc_drop_base (a_index, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9)
     SELECT a_index,
       a_item_percent_0, a_item_percent_1, a_item_percent_2, a_item_percent_3, a_item_percent_4,
       a_item_percent_5, a_item_percent_6, a_item_percent_7, a_item_percent_8, a_item_percent_9
     FROM t_npc;"

echo "==> Seeding zone-wide drop baselines (for DROPRATE multiplier)..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_data -e \
    "CREATE TABLE IF NOT EXISTS laghaim_zone_itemrate_base (
       a_index INT NOT NULL PRIMARY KEY,
       z0 INT NOT NULL DEFAULT 0, z1 INT NOT NULL DEFAULT 0, z2 INT NOT NULL DEFAULT 0,
       z3 INT NOT NULL DEFAULT 0, z4 INT NOT NULL DEFAULT 0, z5 INT NOT NULL DEFAULT 0,
       z6 INT NOT NULL DEFAULT 0, z7 INT NOT NULL DEFAULT 0, z8 INT NOT NULL DEFAULT 0,
       z9 INT NOT NULL DEFAULT 0, z10 INT NOT NULL DEFAULT 0, z11 INT NOT NULL DEFAULT 0,
       z12 INT NOT NULL DEFAULT 0, z13 INT NOT NULL DEFAULT 0, z14 INT NOT NULL DEFAULT 0,
       z15 INT NOT NULL DEFAULT 0, z16 INT NOT NULL DEFAULT 0, z17 INT NOT NULL DEFAULT 0,
       z18 INT NOT NULL DEFAULT 0, z19 INT NOT NULL DEFAULT 0, z20 INT NOT NULL DEFAULT 0,
       z21 INT NOT NULL DEFAULT 0, z22 INT NOT NULL DEFAULT 0, z23 INT NOT NULL DEFAULT 0,
       z24 INT NOT NULL DEFAULT 0, z25 INT NOT NULL DEFAULT 0
     ) ENGINE=InnoDB;
     INSERT IGNORE INTO laghaim_zone_itemrate_base (
       a_index, z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11, z12, z13, z14, z15,
       z16, z17, z18, z19, z20, z21, z22, z23, z24, z25
     )
     SELECT a_index,
       a_zone0, a_zone1, a_zone2, a_zone3, a_zone4, a_zone5, a_zone6, a_zone7, a_zone8, a_zone9,
       a_zone10, a_zone11, a_zone12, a_zone13, a_zone14, a_zone15, a_zone16, a_zone17, a_zone18,
       a_zone19, a_zone20, a_zone21, a_zone22, a_zone23, a_zone24, a_zone25
     FROM t_zone_itemrate;
     CREATE TABLE IF NOT EXISTS laghaim_npc_drop_item_base (
       a_groupnum INT NOT NULL, a_pcroom TINYINT NOT NULL, a_itemindex INT NOT NULL,
       base_rate INT NOT NULL,
       PRIMARY KEY (a_groupnum, a_pcroom, a_itemindex)
     ) ENGINE=InnoDB;
     INSERT IGNORE INTO laghaim_npc_drop_item_base (a_groupnum, a_pcroom, a_itemindex, base_rate)
     SELECT a_groupnum, a_pcroom, a_itemindex, a_itemrate FROM t_npc_drop_item;"

echo "==> Adding gem shops (exchange NPCs 67/180 + buy shop 1871 on world 4)..."
mysql -uroot -p"${ROOT_PW}" kor_ndev_neogeo_data -e \
    "CREATE TABLE IF NOT EXISTS laghaim_gem_item_price_base (
       a_index INT NOT NULL PRIMARY KEY, base_price INT NOT NULL
     ) ENGINE=InnoDB;
     INSERT IGNORE INTO laghaim_gem_item_price_base (a_index, base_price)
     SELECT a_index, a_price FROM t_item
     WHERE a_index IN (215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,1067,1068);
     UPDATE t_item SET a_price = 100
     WHERE a_index IN (215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,1067,1068);
     UPDATE t_shop SET a_keeper_idx=166, a_name='Gem Shopkeeper', a_type=0, a_sell_rate=100, a_enable=1
     WHERE a_index IN (67, 180);
     DELETE FROM t_shopitem WHERE a_shop_idx IN (67, 180);
     INSERT INTO t_shop (
       a_index, a_enable, a_world_num, a_name, a_keeper_idx,
       a_type, a_sell_rate, a_buy_rate, a_pos_x, a_pos_z, a_pos_r
     ) VALUES (
       1871, 1, 4, 'Gem Merchant', 94,
       0, 1, 30, 6720, 5135, 90
     ) ON DUPLICATE KEY UPDATE
       a_enable=VALUES(a_enable), a_world_num=VALUES(a_world_num), a_name=VALUES(a_name),
       a_keeper_idx=VALUES(a_keeper_idx), a_type=VALUES(a_type), a_sell_rate=VALUES(a_sell_rate),
       a_buy_rate=VALUES(a_buy_rate), a_pos_x=VALUES(a_pos_x), a_pos_z=VALUES(a_pos_z), a_pos_r=VALUES(a_pos_r);
     DELETE FROM t_shopitem WHERE a_shop_idx=1871;
     INSERT INTO t_shopitem (a_index,a_shop_idx,a_item_idx,a_plus_point,a_addflag,a_addflag2,a_endurance,a_set_time,a_count,a_price,a_enable) VALUES
       (139001,1871,215,0,0,0,0,0,0,1,1),(139002,1871,216,0,0,0,0,0,0,1,1),(139003,1871,217,0,0,0,0,0,0,1,1),
       (139004,1871,218,0,0,0,0,0,0,1,1),(139005,1871,219,0,0,0,0,0,0,1,1),(139006,1871,220,0,0,0,0,0,0,1,1),
       (139007,1871,221,0,0,0,0,0,0,1,1),(139008,1871,222,0,0,0,0,0,0,1,1),(139009,1871,223,0,0,0,0,0,0,1,1),
       (139010,1871,224,0,0,0,0,0,0,1,1),(139011,1871,225,0,0,0,0,0,0,1,1),(139012,1871,226,0,0,0,0,0,0,1,1),
       (139013,1871,227,0,0,0,0,0,0,1,1),(139014,1871,228,0,0,0,0,0,0,1,1),(139015,1871,229,0,0,0,0,0,0,1,1),
       (139016,1871,1067,0,0,0,0,0,0,1,1),(139017,1871,1068,0,0,0,0,0,0,1,1);"
