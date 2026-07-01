-- Mob drop export for tools/export-mob-drops.ps1
-- rate_scale: roll_0_10000 = direct mob slots; roll_0_1000000 = group drops

SELECT
  'direct' AS drop_type,
  n.a_index AS mob_vnum,
  n.a_name_eng AS mob_name,
  n.a_level AS mob_level,
  n.a_exp AS mob_exp,
  s.slot AS drop_slot,
  s.item_vnum,
  COALESCE(i.a_name_eng, '') AS item_name,
  s.drop_rate,
  'roll_0_10000' AS rate_scale,
  '' AS group_num,
  '' AS group_type
FROM t_npc n
JOIN (
  SELECT a_index, 0 AS slot, a_item_0 AS item_vnum, a_item_percent_0 AS drop_rate FROM t_npc
  UNION ALL SELECT a_index, 1, a_item_1, a_item_percent_1 FROM t_npc
  UNION ALL SELECT a_index, 2, a_item_2, a_item_percent_2 FROM t_npc
  UNION ALL SELECT a_index, 3, a_item_3, a_item_percent_3 FROM t_npc
  UNION ALL SELECT a_index, 4, a_item_4, a_item_percent_4 FROM t_npc
  UNION ALL SELECT a_index, 5, a_item_5, a_item_percent_5 FROM t_npc
  UNION ALL SELECT a_index, 6, a_item_6, a_item_percent_6 FROM t_npc
  UNION ALL SELECT a_index, 7, a_item_7, a_item_percent_7 FROM t_npc
  UNION ALL SELECT a_index, 8, a_item_8, a_item_percent_8 FROM t_npc
  UNION ALL SELECT a_index, 9, a_item_9, a_item_percent_9 FROM t_npc
) s ON s.a_index = n.a_index
LEFT JOIN t_item i ON i.a_index = s.item_vnum
WHERE s.item_vnum > 0 OR s.drop_rate > 0

UNION ALL

SELECT
  'group' AS drop_type,
  nd.a_npc_vnum,
  n.a_name_eng,
  n.a_level,
  n.a_exp,
  g.group_idx,
  di.a_itemindex,
  COALESCE(it.a_name_eng, ''),
  di.a_itemrate,
  'roll_0_1000000',
  g.group_num,
  g.group_type
FROM t_npc_drop nd
JOIN t_npc n ON n.a_index = nd.a_npc_vnum
JOIN (
  SELECT a_npc_vnum, 0 AS group_idx, a_group_type0 AS group_type, a_group_num0 AS group_num FROM t_npc_drop
  UNION ALL SELECT a_npc_vnum, 1, a_group_type1, a_group_num1 FROM t_npc_drop
  UNION ALL SELECT a_npc_vnum, 2, a_group_type2, a_group_num2 FROM t_npc_drop
  UNION ALL SELECT a_npc_vnum, 3, a_group_type3, a_group_num3 FROM t_npc_drop
  UNION ALL SELECT a_npc_vnum, 4, a_group_type4, a_group_num4 FROM t_npc_drop
) g ON g.a_npc_vnum = nd.a_npc_vnum
JOIN t_npc_drop_item di ON di.a_groupnum = g.group_num AND g.group_num > 0
LEFT JOIN t_item it ON it.a_index = di.a_itemindex

ORDER BY mob_vnum, drop_type, drop_slot, item_vnum;
