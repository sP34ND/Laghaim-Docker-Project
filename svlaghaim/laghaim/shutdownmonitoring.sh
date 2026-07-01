#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

rm -f .shutdown

while ( : ) do
    if [ -r .shutdown ]; then
        exit
    fi
    
	if  /bin/ps -elf | /bin/grep 'LhDebug' | /bin/grep $4
	then
		echo "GREEN"
	else
		DATE=`date`
		cp ../bin/LhDebug .
		chmod 755 LhDebug

		gdb --batch --command=cmd --args LhDebug $1 $2 $3 $4 > "log/bt_$2_`date +%y%m%d%H%M%S`.log"

		echo "***** Shtudown *** $3 *** $4 *** $DATE " >> rebootlog
	fi
	sleep 5
done
