#! /bin/bash
work_path="/home/kor/ndev/result_ndev/"
target_path="root@10.1.90.21:/home/lostland/"
rsync -av --delete --exclude=.svn --exclude-from '/home/kor/ndev/result_ndev/excludelist.txt' $work_path $target_path
