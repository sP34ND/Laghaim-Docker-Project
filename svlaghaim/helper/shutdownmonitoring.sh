#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

while ( : ) do
        if  /bin/ps -elf | /bin/grep 'Helper' | /bin/grep $mydir
	then
		echo "GREEN"
	else
		DATE=`date`
		rm -rf Helper
		cp ../bin/Helper .
		chmod 755 Helper
	    ./Helper $1 $2 $3 $mydir &
		echo "***** Shtudown $DATE$ " >> rebootlog
	fi
	sleep 5
done
