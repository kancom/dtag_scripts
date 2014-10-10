#!/bin/bash
#set -x

#global consts
severity=2; #MAJOR

function raisealarm()
{
#$1 - alarm text;
#$2 - source script
  echo -e "LOCK TABLES Event WRITE, Event as tevent READ; INSERT INTO Event  (ID, DISCRIMINATOR, TEXT, CATEGORY, ENTITY, SEVERITY, TTIME, SOURCE, SUBRESOURCE, PROTOCOL)  Select  max(id)+1, 'Event', '$1', 'Script Execution', 'E5-MS_$2', $severity, concat(cast(UNIX_TIMESTAMP() as char(10)),'000'), 'E5-MS', '$2', 'ASCII' from Event as tevent; UNLOCK TABLES;" | /Tekelec/WebNMS/mysql/bin/mysql -uroot -ppublic WebNmsDB;
}

function meas_archive()
{
#returns 0-ok; 1-fatal error; 2-file[s] move error; 3-archive[s] error;
#local consts
  meas_pre_path="/var/E5-MS/measurement/csvoutput/"; #/u01/app/netboss/local/STP/measplat/processed/; #full path with trailing slash/
  meas_post_path="/var/E5-MS/measurement/archive/"; #/u01/app/netboss/local/STP/measplat/archive/; #full path with trailing slash/
  dirprefix="stp"; #(CLLI=stp*)
  yy=$(date +%y);
  yymmdd=$(date +%y%m%d);
#body
  result=1;
  for dir in `ls -d ${meas_pre_path}${dirprefix}*/`; # dirs only like dirprefix* 
  do
    for file in `ls -F "$dir" | grep -v '/' | egrep '[0-9]{4}'`; # files only having 4 digits sequentally (mmdd)
    do
      fdate="${yy}$(egrep -o '[0-9]{4}' <<< $file)";
      if [ "$fdate" == "$yymmdd" ]; then continue; fi
      if ! mkdir -p ${meas_post_path}${fdate}; then result=2; fi
      if ! mv $file ${meas_post_path}${fdate}; then result=2; fi
    done
  done
  for dir in `ls -d ${meas_post_path}*/`; # dirs only
  do
    if tar -cz --directory="${meas_post_path}" \
           -f ${meas_post_path}${fdate}.tgz ${meas_post_path}${fdate}/* \
           && \
           rm -fR ${meas_post_path}${fdate}/ ;
    then
      if [ $result -eq 1 ]; then result=0; fi
    else
      result=3;
    fi
  done
  return $result;
}

function metrica_alarms()
{
#returns 0-ok; 1-fatal error; 2-too old dir[s]; 3-too many files;
#local consts
  inbound_path[0]="/root/E5-MS/measurement/csvinput/"; 
#  inbound_path[1]="/u01/app/netboss/local/STP/measplat/metrica/";
  file_count_inbound_alarm=50;
  inbound_dir_mod_time=3660; #in decimal seconds
  nowutime=$(date +%s);
#body
  result=1;
  for idx in ${!inbound_path[*]};
  do
    for subdir in `ls -d ${inbound_path[$idx]}`; #csvinput doesn't contain sub dirs...
    do
      if [ $(($nowutime-`stat -c%Y $subdir`)) -gt $inbound_dir_mod_time ]; #modification time too far from now
      then
        result=2;
        raisealarm "$subdir did not get measurement report[s] within an hour; Please contact ESOC CN CS" "metrica_alarms";
      fi;
      if [ `ls -A1 $subdir | wc -l` -gt $file_count_inbound_alarm ]; #too many "files"
      then
        result=3;
        raisealarm "There are more than $file_count_inbound_alarm files to be process PLEASE: verify that the tekmeas.pl is running, Please contact ESOC CN CS" "metrica_alarms";
      fi;
    done;
  done;
  return $result;
}

function metrica_file_filter_V2()
{
#returns 0-ok; 1-fatal error; 2-file[s] move error;
#local consts
  meas_pre_path="/var/E5-MS/measurement/csvoutput/"; #/u01/app/netboss/local/STP/measplat/processed #full path with trailing slash/
  archive="/var/E5-MS/measurement/archive/"; #/u01/app/netboss/local/STP/measplat/archive/ #full path with trailing slash/
  metrica="/var/E5-MS/measurement/metrica/"; #/u01/app/netboss/local/STP/measplat/metrica/ #full path with trailing slash/
  processed="/var/E5-MS/measurement/processed/"; #/u01/app/netboss/local/STP/measplat/processed/ #full path with trailing slash/
  whitelistfile="include_metrica_files.bsh";
#body
  result=1;
  for dir in `cd ${meas_pre_path}; ls -d */ | xargs -n1 | egrep '[0-9]{4}'`; #dirs only like with 4 digits in name
  do
    for file in `ls -F "${meas_pre_path}${dir}/*.csv" | egrep -v '.*/'`; #files
    do
      src="${meas_pre_path}${dir}${file}";
      dst="${archive}/$dir";
      if ! mkdir $dst && cp $file $dst; 
      then
        result=2;
        raisealarm "Copy of $file to $dst failed; Please contact ESOC CN CS" "metrica_file_filter_V2";
      fi
      clli=$(sed -n 's/\([a-zA-Z]\+\)_.*/\1/p' <<< $subdir); #ASSUMPTION: each stat file has format CLLI_.*.csv
      dst="${metrica}/${clli}";
      if ! cp $file $dst; #lines 62 of php file
      then
        result=2;
        raisealarm "Move of $file to $dst failed; Please contact ESOC CN CS" "metrica_file_filter_V2";
      fi
      dst="${processed}/${clli}";
      if ! mv $file $dst; #lines 140 of php file
      then
        result=2;
        raisealarm "Move of $file to $dst failed; Please contact ESOC CN CS" "metrica_file_filter_V2";
      fi
      
    done
  done
  whitelist="";
  while read line;
  do
    whitelist=$(sed -n 's/"\([a-z\-]\+\)",/\1/p' <<< $line)"|$whitelist";
  done < $whitelistfile
  whitelist=$(echo $whitelist | sed 's/^|+\|||\||$//g')
  for clli in `ls -d $metrica*/`;
  do
    for file in `cd $clli; ls -d */`;
    do
      do2unix $file $file;
      dst="${metrica}${clli}/moved/";
      if egrep $whitelist $file;
      then
        if ! mkdir -p $dst && mv $file $dst;
        then
          result=2;
          raisealarm "Move of $file to $dst failed; Please contact ESOC CN CS" "metrica_file_filter_V2";
        fi
      else
        rm -f $file;
      fi
    done
  done
  return $result;
}

#main
case "$1" in
  meas_archive)
    meas_archive;;
  metrica_alarms)
    metrica_alarms;;
  metrica_file_filter_V2)
    metrica_file_filter_V2;;
esac

