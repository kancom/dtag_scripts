#!/bin/bash

cd $1;

awk '
{
  if ($0 ~ /> rtrv-gta/) {
    body=0;
    cmd=gensub(/[^a-z0-9\-]/, "", "g");
    fname = cmd ".csv";
    print "START GTA,END GTA,XLAT,RI,ITU PC,MRNSET/MAPSET,SSN,CCGT,CGGTMOD,GTMODID,LOOPSET,OPTSN,CGSELID,OPCSN,ACTSN,PPMEASREQD" > fname;
  }
  if ($0 ~ /START GTA.*END GTA.*XLAT/) {
    body=1;
  } else if (body) {
    $0 = gensub(/^ +| +$/, "", "g");
    $0 = gensub(/([^=]) +([A-Z]+=)/, "\\1,\\2", "g");
    if ($0 ~ /Command/) {$0=""}
    if ($0==";") {
      body=0;
    } else if ($0 ~ /[a-z0-9]+ +[a-z0-9]+/) {
      $0 = gensub(/([^=]) +([^=])/, "\\1,\\2", "g");
      printf "\n%s",$0 >> fname;
    } else if ($0 ~ /[A-Z]+=/) {
      $0 = gensub(/[A-Z]+=/, "", "g");
      printf ",%s", $0 >> fname;
    }
  }
}
' "${2}"

awk '
BEGIN {body=0;}
{
  if ($0 ~ /> rtrv-map/) {
    fname = "rtrv-map.csv";
    print "PCN,Mate PCN,SSN,RC,MULT,SRM,MRC,GRP NAME,SSO,WT,%WT,THR,MAPSET ID,MRNSET ID,MRNPC(N)"  > fname;
  }
  if ($0 ~ /MAPSET ID.*MRNSET ID.*MRNPC/) {
    body=1;
    mapset=gensub(/^ *MAPSET ID=([^ ]+) .*/, "\\1", "g");
    mrnset=gensub(/^.*MRNSET ID=([^ ]+) .*/, "\\1", "g");
    mrnpc=gensub(/^.*MRNPCN? *= *([^ ]+)$/, "\\1", "g");
  } else if (body) {
    $0 = gensub(/^ {7}| +$/, "", "g");
    $0 = gensub(/([^=]) +([A-Z]+=)/, "\\1,\\2", "g");
    if ($0 ~ /Command/) {$0=""}
    if ($0==";") {
      body=0;
    } else if ($0 ~ /^[a-z0-9]+/) {
      $0 = gensub(/ {8,}/, ",,", "g");
      $0 = gensub(/ +/, ",", "g");
      printf "%s,%s,%s,%s\n",$0,mapset,mrnset,mrnpc >> fname;
    } else if ($0 ~ /^ +[a-z0-9]+/) {
      $0 = gensub(/ +/, ",", "g");
      printf "%s\n",$0 >> fname;
    }
  }
}
' "${2}"
