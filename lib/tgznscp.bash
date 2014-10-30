#!/bin/bash

queue="e"; #_e_5-ms
delay=7200; #seconds
severity=2; #MAJOR
remote="osstrans@10.101.21.39:/data/osstrans/upload/TMLAB/Bonn/STP";
arg1=$1; #on setup it's "setup"; on run it's $path
path=$2;

function raisealarm()
{
  echo -e "LOCK TABLES Event WRITE, Event as tevent READ; INSERT INTO Event  (ID, DISCRIMINATOR, TEXT, CATEGORY, ENTITY, SEVERITY, TTIME, SOURCE, SUBRESOURCE, PROTOCOL)  Select  max(id)+1, 'Event', 'Cocoanut results transfer failed', 'Script Execution', 'E5-MS_cocoanut', $severity, concat(cast(UNIX_TIMESTAMP() as char(10)),'000'), 'E5-MS', 'cocoanut', 'ASCII' from Event as tevent; UNLOCK TABLES;" | /Tekelec/WebNMS/mysql/bin/mysql -uroot -ppublic WebNmsDB;
}

function setup()
{
  if atq | grep -E "\W$queue\W" > /dev/null;
  then
    exit 1; #already set
  fi
  echo "${BASH_SOURCE[0]} $path" | at -q $queue `date +%H:%M -d"now +${delay}sec"`;
}

function run()
{
  cd $arg1;
  fname="$(date +%Y%m%d_%H%M).tgz";
  find ./ -name '*.csv' | tar -czf $fname -T -
  if ! sftp $fname $remote && rm -f $fname;
  then
    raisealarm;
  fi
  find $arg1 -name '*.csv' -type f -delete
  cd ..
}

if [ "$1" = "setup" ]
then
  setup;
else
  run;  
fi
