#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

export MALLOC_CHECK_=2

nohup ./shutdownmonitoring.sh  1 7 660 whitehorn_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 8 660 white_dungeon_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 4 660 start_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 6 660 sky_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 5 660 roost_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 2 660 quest_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 3 660 guild_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 1 660 dekarendungeon_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 9 660 dmitron_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 0 660 decard_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 14 660 boss_cai_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 12 660 occp_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 22 660 forlorn_zone2_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 20 660 disposal_plant_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 16 660 boss_man_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 17 660 boss_hib_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 13 660 boss_bul_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 15 660 boss_aid_ch0 1> /dev/null 2>&1 &

nohup ./shutdownmonitoring.sh  1 18 660 boss_last_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 11 660 battle_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 23 660 forlorn_zone3_ch0 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 24 660 forlorn_zone4_ch0 1> /dev/null 2>&1 &


#nohup ./shutdownmonitoring.sh  1 10 660 matrix_ch0 1> /dev/null 2>&1 &
#nohup ./shutdownmonitoring.sh  1 19 660 mobius_arena_ch0 1> /dev/null 2>&1 &
