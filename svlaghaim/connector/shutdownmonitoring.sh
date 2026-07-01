#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

while ( : ) do
        if  /bin/ps -elf | /bin/grep 'Connector' | /bin/grep $mydir
	then
		echo "GREEN"
	else
		DATE=`date`
		rm -rf Connector
		cp ../bin/Connector .
		chmod 755 Connector
		./Connector $1 $2 $3 $mydir &
		echo "***** Shtudown $DATE$ " >> rebootlog.txt
	fi
	sleep 5
done
