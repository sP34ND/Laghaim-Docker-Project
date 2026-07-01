#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

export MALLOC_CHECK_=2

nohup ./shutdownmonitoring.sh  1 7 661 whitehorn_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 8 661 white_dungeon_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 4 661 start_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 6 661 sky_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 5 661 roost_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 2 661 quest_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 3 661 guild_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 1 661 dekarendungeon_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 9 661 dmitron_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 0 661 decard_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 14 661 boss_cai_ch1 1> /dev/null 2>&1 &
#nohup ./shutdownmonitoring.sh  1 12 661 occp_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 22 661 forlorn_zone2_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 23 661 forlorn_zone3_ch0 1> /dev/null 2>&1 &

nohup ./shutdownmonitoring.sh  1 20 661 disposal_plant_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 16 661 boss_man_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 17 661 boss_hib_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 13 661 boss_bul_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 15 661 boss_aid_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 18 661 boss_last_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 19 661 matrix_new_ch1 1> /dev/null 2>&1 &
nohup ./shutdownmonitoring.sh  1 11 661 battle_ch1 1> /dev/null 2>&1 &
