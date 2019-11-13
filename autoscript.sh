#!/bin/bash

ACTION='\033[1;90m'
 FINISHED='\033[1;96m'
 READY='\033[1;92m'
 NOCOLOR='\033[0m' # No Color
 ERROR='\033[0;31m'
 proc_name='native_client'

function killProcess()
{
if pgrep $proc_name
then
echo " $proc_name running "
pkill $proc_name
echo "$proc_name  got killed"
else
echo " $proc_name is not running/stopped "
fi
}
function keepAlive()
{
if pgrep $proc_name
then
echo " Alive "
else
./../sauerbraten_unix &
fi
}

 while true; do 
 echo -e ${ACTION}Checking Git repo
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
 
 else
   echo -e ${FINISHED}Current branch is up to date with origin/master.${NOCOLOR}
 fi
 keepAlive
done
