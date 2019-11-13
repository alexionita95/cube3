#!/bin/sh

ACTION='\033[1;90m'
 FINISHED='\033[1;96m'
 READY='\033[1;92m'
 NOCOLOR='\033[0m' # No Color
 ERROR='\033[0;31m'
 proc_name='native_client'

killProcess()
{
if pgrep $proc_name
then
echo ""
pkill $proc_name

else
echo ""
fi
}
keepAlive()
{
if pgrep $proc_name
then
echo ""
else
cd ../
./sauerbraten_unix -d2 &
cd src
fi
}

 while true; do 
 git fetch
 HEADHASH=$(git rev-parse HEAD)
 UPSTREAMHASH=$(git rev-parse master@{upstream})

 if [ "$HEADHASH" != "$UPSTREAMHASH" ]; then
	echo -e ${ACTION}Update available...
	echo -e ${ACTION}Updating...
	git pull
	echo -e ${ACTION}Stopping server...
	killProcess
	echo -e ${ACTION}Building new sources...
	make install
	echo -e ${ACTION}Done updating.
 fi
 keepAlive
done
