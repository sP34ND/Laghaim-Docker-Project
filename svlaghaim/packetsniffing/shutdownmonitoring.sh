#! /bin/bash
mydir=`pwd|awk -F/ '{print $NF}'`

while ( : ) do
        if  /bin/ps -elf | /bin/grep 'PacketSniffing' | /bin/grep $mydir
	then
		echo "GREEN"
	else
		DATE=`date`
		rm -rf PacketSniffing
		cp ../bin/PacketSniffing .
		chmod 755 PacketSniffing
	    ./PacketSniffing $mydir &
		echo "***** Shtudown $DATE$ " >> rebootlog
	fi
	sleep 5
done
