#!/bin/bash

cd $1;

dos2unix "$2"

LANG=C
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

gawk --re-interval '
BEGIN {body=0;}
{
  fname = "rtrv-assoc.csv";
  if ($0 ~ /> rtrv-assoc/) {
    print "ANAME,LOC,IPLNK,LINK,ADAPTER,VER,LHOST,ALHOST,RHOST,ARHOST,LPORT,RPORT,ISTRMS,OSTRMS,BUFSIZE,RMODE,RMIN,RMAX,RTIMES,CWMIN,UAPS,OPEN,ALW,RTXTHR,RHOSTVAL,M2PATSET" > fname;
    cmd=1;
  }
  if ((cmd) &&($0 ~ / +ANAME.*/)) {
    body=1;
    fst = substr($0, 11);
    fst = gensub(/^ +| +$/, "", "g", fst);
    printf "\n%s,", fst >> fname;
  } else if (body) {
    if ($0 ~ /Command/) {$0=""}
    if ($0==";") {
      body=0;
      cmd=0;
    } else if ($0 ~ /          [A-Z]+.*/) {
      fst = substr($0, 20, 14);
      fst = gensub(/^ +| +$/, "", "g", fst);
      printf "%s,", fst >> fname;
      if (length($0)>45) {
        scd = substr($0, 45, 12);
        scd = gensub(/^ +| +$/, "", "g", scd);
        scd = gensub(/,/, ".", "g", scd);
        printf "%s,", scd >> fname;
      }
      if (length($0)>66) {
        thd = substr($0, 66);
        thd = gensub(/^ +| +$/, "", "g", thd);
        printf "%s,", thd >> fname;
      }
    }
  }
}
' "${2}"

gawk --re-interval '
function rewind(i)
{
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]
    ARGC++
    ARGV[ARGIND+1] = FILENAME
    nextfile
}
BEGIN {
  body=0;
  cnt=1;
  fname = "rtrv-ls:lsn.csv";
  printhdr = 1;
}
{
  if ($0 ~ /rtrv-ls:lsn=/) {body=1;}
  if ($0 ~ /Command Executed/) {body=0;}
  if ($0 ~ /Script execution completed/) { # rewind to the beginning of file for 2nd pass
    pass++;
    if (pass==1) {
      rewind(1);
    }
  }
  if (body==0) {next;}
  if (pass!=1) { #first passs - only reading all headers
    if ($0 ~ /^ +[A-Z]{3,}.*$/) { #header line
      cls = split($0, hdrs);
      for (i=1; i<=cls; i++) {
        if ((hdrs[i] ~ /^[A-Z0-9]+$/) && (!HEADERS[hdrs[i]])) {
          HEADERS[hdrs[i]] = 1;
          HEADERS_R[cnt] = hdrs[i];
          cnt++;
        }
      }
    }
  } else { #second pass - reading data
    if (printhdr) {
      for (i=1; i<cnt; i++) {
        printf "%s,", HEADERS_R[i] > fname;
      }
      printf "\n" >> fname;
      printhdr = 0;
    } else {
      if ($0 ~ /^ +[A-Z]{3,}.*$/) { #header line
        prevhdr=$0;
        prevhdr = gensub(/\(SS7\)/, "     ", "g", prevhdr);
      } else { #data line
        if ($0 ~ /^ +$/) {
          prevhdr="";
        }
        cls = split(prevhdr, hdrs);
        for (i=1; i<cls; i++) {
          if (hdrs[i] ~ /^[A-Z0-9]+$/) {
            if (hdrs[i] == "LSN") {
              for (hdr in HEADERS) {
                HEADERS[hdr] = "";
              }
            }
            pos_s = index(prevhdr, hdrs[i]);
            pos_e = index(prevhdr, hdrs[i+1]);
            data = substr($0, pos_s, pos_e - pos_s);
            data = gensub(/^ +| +$/, "", "g", data);
            data = gensub(/,/, ".", "g", data);
            if ((hdrs[i] == "LOC") && (length(data)>10)) {
              data = substr(data, 1, index(data, " "));
            }
            HEADERS[hdrs[i]] = data;
          }
        }
        if (prevhdr!="") {
          pos_s = index(prevhdr, hdrs[cls]);
          data = substr($0, pos_s);
          data = gensub(/^ +| +$/, "", "g", data);
          HEADERS[hdrs[cls]] = data;
          if (hdrs[cls] ~ /ANAME|TS/) {
            for (i=1; i<cnt; i++) {
              printf "%s,", HEADERS[HEADERS_R[i]] >> fname;
            }
            printf "\n" >> fname;
          }
        }
      }
    }
  }
}
' "${2}"
