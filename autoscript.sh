#!/bin/sh

ACTION='\033[1;90m'
 FINISHED='\033[1;96m'
 READY='\033[1;92m'
 NOCOLOR='\033[0m' # No Color
 ERROR='\033[0;31m'
 proc_name='native_client'

killProcess()
{
if pgrep -x $proc_name > /dev/null; then
echo
else
pkill $proc_name
fi
}
keepAlive()
{
if pgrep -x $proc_name > /dev/null; then
echo
else
cd ../
./sauerbraten_unix -d2 &
cd src
fi
}

 while true; do 
 echo -e =======================${NOCOLOR}
 BRANCH=$(git rev-parse --abbrev-ref HEAD)
 git fetch
 HEADHASH=$(git rev-parse HEAD)
 UPSTREAMHASH=$(git rev-parse master@{upstream})

 if [ "$HEADHASH" != "$UPSTREAMHASH" ]
 then
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
