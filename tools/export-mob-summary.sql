-- All mobs with drop counts (current DB values incl. EXPRATE/DROPRATE multipliers)
SELECT
  n.a_index AS mob_vnum,
  n.a_name_eng AS mob_name,
  n.a_level AS mob_level,
  n.a_exp AS mob_exp,
  COALESCE(b.base_exp, n.a_exp) AS base_exp,
  (
    (n.a_item_0 > 0) + (n.a_item_1 > 0) + (n.a_item_2 > 0) + (n.a_item_3 > 0) + (n.a_item_4 > 0) +
    (n.a_item_5 > 0) + (n.a_item_6 > 0) + (n.a_item_7 > 0) + (n.a_item_8 > 0) + (n.a_item_9 > 0)
  ) AS direct_item_slots,
  (
    (n.a_item_percent_0 > 0) + (n.a_item_percent_1 > 0) + (n.a_item_percent_2 > 0) + (n.a_item_percent_3 > 0) +
    (n.a_item_percent_4 > 0) + (n.a_item_percent_5 > 0) + (n.a_item_percent_6 > 0) + (n.a_item_percent_7 > 0) +
    (n.a_item_percent_8 > 0) + (n.a_item_percent_9 > 0)
  ) AS direct_rate_slots,
  IF(nd.a_npc_vnum IS NULL, 0, 1) AS has_group_drop_table,
  IF(zn.a_npc_idx IS NULL, 0, 1) AS spawns_in_world
FROM t_npc n
LEFT JOIN laghaim_npc_exp_base b ON b.a_index = n.a_index
LEFT JOIN t_npc_drop nd ON nd.a_npc_vnum = n.a_index
LEFT JOIN (SELECT DISTINCT a_npc_idx FROM t_zone_npc) zn ON zn.a_npc_idx = n.a_index
ORDER BY n.a_index;
