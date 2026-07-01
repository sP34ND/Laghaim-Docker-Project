#/bin/bash
./kill.sh
sleep 5
if cd messenger
then
        ./start.sh
        cd ..
fi
if cd connector
then
        ./start.sh 692 1 1 1
        cd ..
fi
if cd helper
then
        ./start.sh 612 1 1 1
        cd ..
fi
if cd laghaim
then
	./ch0_start.sh
	cd ..
fi
if cd packetsniffing
then
	./start.sh 
	cd ..
fi
