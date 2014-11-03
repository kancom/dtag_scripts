#!/bin/bash

cd $1;

awk '
BEGIN {body=0;}
{
  if ($0 ~ /> rtrv-gta/) {
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
