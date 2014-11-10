#!/bin/bash

cd $1;

dos2unix "$2"

awk --re-interval '
{
  if ($0 ~ /> rtrv-gta/) {
    body=0;
    cmd=gensub(/[^a-z0-9\-=:]/, "", "g");
    fname = cmd ".csv";
    print "START GTA,END GTA,XLAT,RI,ITU PC,MRNSET,MAPSET,SSN,CCGT,CGGTMOD,GTMODID,TESTMODE,LOOPSET,FALLBACK,OPTSN,CGSELID,CDSELID,OPCSN,ACTSN,PPMEASREQD" > fname;
  }
  if ($0 ~ /START GTA.*END GTA.*XLAT/) {
    body=1;
  } else if (body) {
    $0 = gensub(/^ +| +$/, "", "g");
    $0 = gensub(/ *= */, "=", "g");
    if ($0 ~ /Command/) {
      $0="";
      printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", SGTA, EGTA, XLAT, RI, ITUPC, MRNSET, MAPSET, SSN, CCGT, CGGTMOD, GTMODID, TESTMODE, LOOPSET, FALLBACK, OPTSN, CGSELID, CDSELID, OPCSN, ACTSN, PPMEASREQD >> fname;
      SGTA = EGTA = XLAT = RI = ITUPC = MRNSET = MAPSET = SSN = CCGT = CGGTMOD = GTMODID = TESTMODE = LOOPSET = FALLBACK = OPTSN = CGSELID = CDSELID = OPCSN = ACTSN = PPMEASREQD = "";
    }
    if ($0==";") {
      body=0;
    } else if ($0 ~ /[a-z]*[0-9]+ +[a-z]*[0-9]+/) {
      printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", SGTA, EGTA, XLAT, RI, ITUPC, MRNSET, MAPSET, SSN, CCGT, CGGTMOD, GTMODID, TESTMODE, LOOPSET, FALLBACK, OPTSN, CGSELID, CDSELID, OPCSN, ACTSN, PPMEASREQD >> fname;
      SGTA = EGTA = XLAT = RI = ITUPC = MRNSET = MAPSET = SSN = CCGT = CGGTMOD = GTMODID = TESTMODE = LOOPSET = FALLBACK = OPTSN = CGSELID = CDSELID = OPCSN = ACTSN = PPMEASREQD = "";
      if (match($0, /^([[:alnum:]]+).*/)) {
        SGTA=gensub(/^([[:alnum:]]+).*/, "\\1", "g");
      }
      if (match($0, /^([[:alnum:]]+ +){1}([[:alnum:]]+).*/)) {
        EGTA=gensub(/^([[:alnum:]]+ +){1}([[:alnum:]]+).*/, "\\2", "g");
      }
      if (match($0, /^([[:alnum:]]+ +){2}([[:alnum:]]+).*/)) {
        XLAT=gensub(/^([[:alnum:]]+ +){2}([[:alnum:]]+).*/, "\\2", "g");
      }
      if (match($0, /^([[:alnum:]]+ +){3}([[:alnum:]]+).*/)) {
        RI=gensub(/^([[:alnum:]]+ +){3}([[:alnum:]]+).*/, "\\2", "g");
      }
      if (match($0, /^([[:alnum:]]+ +){4}.*$/)) {
        ITUPC=gensub(/^([[:alnum:]]+ +){4}(.*)$/, "\\2", "g");
      }
    } else if ($0 ~ /[A-Z]+=/) {
      if ($0 ~ /MRNSET/) {
        MRNSET = gensub(/.*MRNSET=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /MAPSET/) {
        MAPSET = gensub(/.*MAPSET=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /SSN/) {
        SSN = gensub(/.*SSN=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /CCGT/) {
        CCGT = gensub(/.*CCGT=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /CGGTMOD/) {
        CGGTMOD = gensub(/.*CGGTMOD=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /GTMODID/) {
        GTMODID = gensub(/.*GTMODID=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /TESTMODE/) {
        TESTMODE = gensub(/.*TESTMODE=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /LOOPSET/) {
        LOOPSET = gensub(/.*LOOPSET=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /FALLBACK/) {
        FALLBACK = gensub(/.*FALLBACK=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /OPTSN/) {
        OPTSN = gensub(/.*OPTSN=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /CGSELID/) {
        CGSELID = gensub(/.*CGSELID=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /CDSELID/) {
        CDSELID = gensub(/.*CDSELID=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /OPCSN/) {
        OPCSN = gensub(/.*OPCSN=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /ACTSN/) {
        ACTSN = gensub(/.*ACTSN=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }
      if ($0 ~ /PPMEASREQD/) {
        PPMEASREQD = gensub(/.*PPMEASREQD=([A-Za-z0-9\-]+).*/, "\\1", "g");
      }

    }
  }
}
' "${2}"

gawk --re-interval '
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
    } else if ($0 ~ /^[0-9]+[a-z]*/) {
      $0 = gensub(/ {8,}/, ",,", "g");
      $0 = gensub(/ +/, ",", "g");
      printf "%s,%s,%s,%s\n",$0,mapset,mrnset,mrnpc >> fname;
    } else if ($0 ~ /^ +[0-9]+[a-z]*/) {
      $0 = gensub(/ +/, ",", "g");
      printf "%s\n",$0 >> fname;
    }
  }
}
' "${2}"
