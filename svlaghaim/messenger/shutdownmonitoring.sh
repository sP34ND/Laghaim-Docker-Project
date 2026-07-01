#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

while ( : ) do
        if  /bin/ps -elf | /bin/grep 'Messenger' | /bin/grep $mydir
	then
		echo "GREEN"
	else
		DATE=`date`
		rm -rf Messenger
		cp ../bin/Messenger .
		chmod 755 Messenger
	    ./Messenger $mydir &
		echo "***** Shtudown $DATE$ " >> rebootlog
	fi
	sleep 5
done
