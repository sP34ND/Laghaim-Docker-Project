-- Zone-wide drops (any mob kill in that world rolls these)
SELECT
  zd.a_item_index AS item_vnum,
  zd.a_item_name AS item_name,
  zd.a_item_count AS item_count,
  zd.a_item_pluspoint AS item_plus,
  zd.a_item_levelcap AS level_cap,
  zd.a_zone_itemrate_num AS rate_profile,
  zir.a_index AS rate_profile_id,
  zir.a_zone0, zir.a_zone1, zir.a_zone2, zir.a_zone3, zir.a_zone4,
  zir.a_zone5, zir.a_zone6, zir.a_zone7, zir.a_zone8, zir.a_zone9,
  zir.a_zone10, zir.a_zone11, zir.a_zone12, zir.a_zone13, zir.a_zone14,
  zir.a_zone15, zir.a_zone16, zir.a_zone17, zir.a_zone18, zir.a_zone19,
  zir.a_zone20, zir.a_zone21, zir.a_zone22, zir.a_zone23, zir.a_zone24,
  zir.a_zone25
FROM t_zone_drop zd
LEFT JOIN t_zone_itemrate zir
  ON zir.a_index = zd.a_zone_itemrate_num AND zir.a_enable = 1
WHERE zd.a_enable = 1
ORDER BY zd.a_item_index;
