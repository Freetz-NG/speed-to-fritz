#!/bin/bash
get_fw_ftp()
{
echo "-- checking $1/$2 for latest firmware file ..."
#rm -f $2/.listing
(wget --spider --no-remove-listing -r -P "$3" "$1/$2/" 2>&1) > $3/.-log
    cat "./0/.-log" | grep -o "ftp://.*$" >> "./0/list_0"
#    cat "./0/.$2-log" | grep -o "\.image.*$" >> "./0/list_0"
    sed -i  -e "/\/$/d" "./0/list_0"
    sed -i -e '$!N; /^\(.*\)\n\1$/!P; D' "./0/list_0"
#    sed -i -e "s|||g" "./0/list_0"
#    sed -i -e '/\.exe/{n;d}' "./0/list_0"
    sed -i -e "/\.exe/d" -e "/\/$/d" "./0/list_0"
#    sed -i -e "/license.txt/d" "./0/list_0"
    sed -i -e "/\.txt/d" -e "/tar\.gz/d" -e "/\.me/d" "./0/list_0"
    sed -i -e "/\.xpi/d" -e "/\.rdf/d" "./0/list_0"
    sed -i -e "/Setup/d" "./0/list_0"
return 0
}
get_fw_http()
{
echo "-- checking $1/$2 for latest firmware file ..."
#rm -f $2/.listing
(wget --spider --no-remove-listing -r -P "$3" "$1/$2/" 2>&1) > $3/.-logh
    cat "./0/.-logh" | grep -o "ftp://.*$" >> "./0/listh_0"
#    cat "./0/.$2-logh" | grep -o "\.image.*$" >> "./0/listh_0"
    sed -i  -e "/\/$/d" "./0/listh_0"
    sed -i -e '$!N; /^\(.*\)\n\1$/!P; D' "./0/listh_0"
return 0
}
#   $1:         full download path to *.php                             #
#   $2:         local directory where images are stored                 #
#   $3:         HWrevision     HWXXX:                                   #
#   $4:         Return imagename full path                              #
#   $5:         Return image name                                       #
#   $6:         Return date                                             #
#   $7:         Return AVM Type                                         #
function get_php()
{
DLD_PATH="${1%/*}/"
IMG_REQ="${1##*/}"
DLD_DIR="$2"
#EXT="${1##*.}"
echo "-- checking AVM Labor php for latest $3 firmware file ..."
rm -f $DLD_DIR/$IMG_REQ
rm -f $DLD_DIR/index*
(wget -P "$DLD_DIR" "$1" 2>&1) > /dev/null
if [ ! -e $DLD_DIR/$IMG_REQ ]; then 
 	return 0
else
  LOCAL_HWID=${3:2:3}
#  echo LOCAL_HWID: $LOCAL_HWID
  cat "$DLD_DIR/$IMG_REQ" | sed -n "/<div  id=.B_$LOCAL_HWID.>/,/<\/div>/{/diese Hardware-Version der.*/p}" | grep -q 'diese Hardware-Version der' && echo "There is no Labor firmware for this Hardware version $LOCAL_HWID avalabel!" && sleep 20
  IMG_REQ1="$(cat "$DLD_DIR/$IMG_REQ" | sed -n "/<div  id=.B_$LOCAL_HWID.>/,/<\/div>/{/<a href=.*/p}" | sed "s/.*<a href=\"//" | sed "s/\".*//")"
  #echo IMG_REQ1: $IMG_REQ1
      REVISON="$(echo "$IMG_REQ1" | sed -e 's/^.*\(.\{5\}\)....$/\1/' | tr -d '[:alpha:]')"
      XXVERSION="$(cat "$DLD_DIR/$IMG_REQ" | sed -n "/<div  id=.B_$LOCAL_HWID.>/,/Datum/{/Version/{n;p}}" | sed "s/.*<td>//" | sed "s/<\/td>//" | sed "s///")"
      DATUM="$(cat "$DLD_DIR/$IMG_REQ" | sed -n "/<div  id=.B_$LOCAL_HWID.>/,/Datum/{/Datum/{n;p}}" | sed "s/.*<td>//" | sed "s/<\/td>//" | sed "s///")"
      #echo "XXVERSION: $XXVERSION"
      #Y_version=${XXVERSION:0:2}
      #Y_mayorversion=${XXVERSION:3:2}
      #Y_minorversion=${XXVERSION:6:2}
      #Y_subversion=${XXVERSION:9:5}
      AVMNUM="$(cat "$DLD_DIR/$IMG_REQ" | grep "H_$LOCAL_HWID" | sed -e "s/0 v//" | sed -e "s/<\/h3>//" | sed -e 's/^.*\(.\{4\}\).$/\1/' | tr -d '[:alpha:]' )"
      #echo "AVMNUM: $AVMNUM"
      #echo "AVM Type: $AVMNUM, New Firmware Version: $Y_version.$Y_mayorversion.$Y_minorversion-$Y_subversion, New subversion: $REVISON"
      type=${AVMNUM}
      echo $IMG_REQ1 | grep -q "v1" && type="${AVMNUM}v1-${REVISON}"
      echo $IMG_REQ1 | grep -q "v2" && type="${AVMNUM}v2-${REVISON}"
      echo $IMG_REQ1 | grep -q "v3" && type="${AVMNUM}v3-${REVISON}"
      eval "export $5=${XXVERSION}"
      eval "export $6=${DATUM}"
      eval "export $7=${type}"
      eval "export $4=${DLD_PATH}${IMG_REQ1}"
fi
return 0
}
get_fw_all()
{
echo "-- Be patient, download may need more as fifteen minutes ..."
rm -f ./0/hist-deu.txt
get_fw_ftp ftp://ftp.avm.de fritz.box ./0
get_fw_ftp ftp://service.avm.de/.. 38.04.56 ./0
get_fw_ftp ftp://service.avm.de/.. 7141_AOL ./0
get_fw_ftp ftp://service.avm.de/.. 7270_v3 ./0
get_fw_ftp ftp://service.avm.de/.. Arcor6000 ./0
get_fw_ftp ftp://service.avm.de/.. Beta ./0
get_fw_ftp ftp://service.avm.de/.. Downgrade ./0
get_fw_ftp ftp://service.avm.de/.. F32_Arcor ./0
get_fw_ftp ftp://service.avm.de/.. Labor ./0
get_fw_ftp ftp://service.avm.de/.. Streaming_Stick ./0
get_fw_ftp ftp://service.avm.de/.. xx.04.76 ./0
rm -f "./0/hist-deu.txt"
rm -f "./0/hist-eng.txt"
wget  -P "./0" ftp://ftp.avm.de/hist-deu.txt
wget  -P "./0" ftp://ftp.avm.de/hist-eng.txt
cat ./0/hist-deu.txt > ./0/hist.txt
cat ./0/hist-eng.txt >> ./0/hist.txt
}
! [ -d ./0 ] && mkdir ./0
rm -f "./0/log_1"
rm -f "./0/log_s"
rm -f "./0/log_s1"
echo " -- For aditional files edit ./0/extra.txt, we only automaticaly generate AVM links!"
info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7390_hausautomation/labor_start_vorschau_release_candidate.php"
get_php "$info_l" "./0" "HW156:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_HA" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5

info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7390_vorschau_release_candidate_at_ch/labor_start_vorschau_release_candidate.php"
get_php "$info_l" "./0" "HW156:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_Beta" l="Deutsch_at_ch" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5

info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7390_vorschau_release_candidate/labor_start_7390.php"
get_php "$info_l" "./0" "HW156:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_Beta" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5
#7270v2
info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7270_vorschau_release_candidate/labor_start_vorschau_release_candidate_labor.php"
get_php "$info_l" "./0" "HW145:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_Beta" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5
#7270v3
info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7270_vorschau_release_candidate/labor_start_vorschau_release_candidate_labor.php"
get_php "$info_l" "./0" "HW139:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_Beta" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5
#7270v2
info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7270_dsl/labor_start_dsl.php"
get_php "$info_l" "./0" "HW145:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_DSL" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5
#7270v3
info_l="http://www.avm.de/de/Service/Service-Portale/Labor/7270_dsl/labor_start_dsl.php"
get_php "$info_l" "./0" "HW139:" "ftpline" "Version" "Build" "name"
! [ -z "$name" ] && echo "$name n=$name v=$Version d=$ftpline t="Labor_DSL" l="-" b=$Build i=$info_l " >> "./0/log_s"
[ -z "$name" ] && echo "Labor firmware link not found!" && sleep 5
echo " -- More to look for ..."
get_fw_all
echo " -- More time needed be patient ..."
#no aditional firmware on http- not needed
#get_fw_http http://download.avm.de fritz.box ./0
cat <<SETEOF > ./0/firmware-download-liste.xhtml
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title /><meta name="AVM firmware link liste" content="" />
		<meta name="author" content="Johann Pascher" />
		<base href="." /><style type="text/css">
		@page {  }
		table { border-collapse:collapse; border-spacing:0; empty-cells:show }
		td, th { vertical-align:top; }
		h1, h2, h3, h4, h5, h6 { clear:both }
		ol, ul { padding:0; }
		* { margin:0; }
		*.ta1 { }
		*.ce2 { font-family:Arial; background-color:#4d4d4d; border-width:0.0133cm; border-style:solid; border-color:#000000; padding:0.035cm; vertical-align:top; text-align:left ! important; margin-left:0cm; color:#ffffff; font-size:10pt; font-style:normal; text-shadow:none; font-weight:normal; }
		*.ce7 { font-family:Arial; border-bottom-width:0.088cm; border-bottom-style:solid; border-bottom-color:#000000; background-color:#0099ff; border-left-width:0.018cm; border-left-style:solid; border-left-color:#000000; padding:0.035cm; border-right-width:0.018cm; border-right-style:solid; border-right-color:#000000; border-top-width:0.018cm; border-top-style:solid; border-top-color:#000000; vertical-align:top; margin-left:0cm; color:#ffffff; font-size:10pt; font-style:normal; text-shadow:none; font-weight:normal; }
		*.ce8 { font-family:Arial; background-color:#ffffff; border-width:0.0133cm; border-style:solid; border-color:#000000; padding:0.035cm; vertical-align:top; margin-left:0cm; color:#000000; font-size:10pt; font-style:normal; text-shadow:none; font-weight:normal; }
		*.Default { font-family:Arial; }
		</style>
	</head>
	<body dir="ltr">
		<table border="0" cellspacing="0" cellpadding="0" class="ta1" style="text-align:left;">
				<tr class="ro1">
					<td class="ce7">
						<p>Modell</p>
					</td>
					<td class="ce7">
						<p>Firmware</p>
					</td>
					<td class="ce7">
						<p>Download</p>
					</td> 
					<td class="ce7">
						<p>Annex</p>
					</td>
					<td class="ce7">
						<p>Sprache</p>
					</td>
					<td class="ce7">
						<p>Datum</p>
					</td>
					<td class="ce7">
						<p>Info</p>
					</td>
				</tr>
SETEOF
echo "^  Modell  ^  Firmware ^  Download ^  Annex  ^  Sprache  ^  Datum  ^  Info  ^" > "./0/wiki.lst"
while read ftpline
do
DLD_PATH="${ftpline%/*}/"
IMG_REQ="${ftpline##*/}"
Version1=$(echo $IMG_REQ | grep -o "\.[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]\.\|\.[0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]\.")
Version=$(echo $Version1 | grep -o "[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]\|[0-9][0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]")
name=$(echo $IMG_REQ | grep -o "[0-9].*\|repeater.*"  | sed -e "s/\.image//g" -e "s/\.zip//g" -e "s/${Version}//g" -e "s/.$//g")
##! [ -z "$Version" ] && echo $Version
subdir=$(echo $DLD_PATH | sed -e "s/\.\./%2E%2E/g" -e "s/%20/ /g" -e "s/ftp:\/\//\.\/0\//g")
#echo $subdir
##get file date
temp=$(cat "$subdir.listing" | grep $IMG_REQ | sed -e "s/..:../ $(date +%Y)/g")
Build=$(echo "${temp:43:12}" | sed -e "s/ /_/g" )
! [ -z "$Version" ] && Build1=$(cat ./0/hist.txt | grep -A4 "$Version" | grep -o "uild.*" | grep -o "[0-9][0-9]\.[0-9][0-9]\.[0-9][0-9]")
! [ -z "$Build1" ] && Build=$(echo "${Build1:6:2}.${Build1:3:2}.${Build1:0:2}")
#! [ -z "$Build1" ] && echo $Build
[ -z "$name" ] && name=$(echo $IMG_REQ | grep -o ".epeater\.en")
[ -z "$name" ] && name=$(echo $IMG_REQ | grep -o ".epeater_....")
[ -z "$name" ] && name="-" 
type=
lang=
if ! [ -z "$DLD_PATH" ]; then
    [ -z "$type" ] && echo $IMG_REQ | grep -q "\.en-de" && type="Multi"
    [ -z "$type" ] && echo $IMG_REQ | grep -q "nnexA" && type="A"
    [ -z "$type" ] && echo $IMG_REQ | grep -q "nnexB" && type="B"
    [ -z "$type" ] && echo $IMG_REQ | grep -q "nnexa" && type="A"
    [ -z "$type" ] && echo $IMG_REQ | grep -q "nnexb" && type="B"
    [ -z "$type" ] && echo $DLD_PATH | grep -q "\/annex_a\/" && type="A"
    [ -z "$type" ] && echo $DLD_PATH | grep -q "\/annex_b\/" && type="B"

    [ -z "$lang" ] && echo $IMG_REQ | grep -q "\.de-en-es-it-fr" && lang="de-en-es-it-fr"
    [ -z "$lang" ] && echo $IMG_REQ | grep -q "\.en-de-es-it-fr" && lang="en-de-es-it-fr"
    [ -z "$lang" ] && echo $IMG_REQ | grep -q "\.en-de-fr" && lang="en-de-fr"
    [ -z "$lang" ] && echo $DLD_PATH | grep -q "\/deutsch_a-ch\/" && lang="Deutsch_a-ch"
    [ -z "$lang" ] && echo $DLD_PATH | grep -q "\/deutsch\/" && lang="Deutsch"
    [ -z "$lang" ] && echo $DLD_PATH | grep -q "\/englisch\/" && lang="Englisch"
    [ -z "$lang" ] && echo $IMG_REQ | grep -q "\.en" && lang="Englisch"
fi
[ -z "$lang" ] && lang="-"
[ -z "$type" ] && type="-"
#echo $lang , $type
cat "$subdir.listing" | grep -q "info-870480.txt" && info_l=${DLD_PATH}info-870480.txt
cat "$subdir.listing" | grep -q "info.txt" && info_l=${DLD_PATH}info.txt
cat "$subdir.listing" | grep -q ".php" && info_l=${DLD_PATH}
cat "$subdir.listing" | grep -q "license.txt" && info_l="-"
#cat "$subdir.listing" | grep -A2 $IMG_REQ

#echo "^  Modell  ^  Firmware ^  Download ^  Annex   ^  Sprache  ^  Datum  ^  Info  ^" > "./0/log_1"
! [ -z "$Version" ] && echo "$name n=$name v=$Version d=$ftpline t=$type l=$lang b=$Build i=$info_l " >> "./0/log_s"
done < "./0/list_0"
cat "./0/extra.txt" >> "./0/log_s"
#---
cat "./0/log_s" | sort > "./0/log_s1"
sed -i  -e "/\/$/d" "./0/log_s1"
sed -i -e '$!N; /^\(.*\)\n\1$/!P; D' "./0/log_s1"
cat "./0/log_s1" > "./0/log_s"
sed -i -e "/epeater/!d" "./0/log_s"
sed -i -e "/epeater/d" "./0/log_s1"
cat "./0/log_s" >> "./0/log_s1"
name="-"
Version="-"
ftpline="-"
type="-"
lang="-"
Build="-"
info_l="-"
while read ftpline
do
#---------------->
for i in $ftpline
do
case $i in
n=*)
name=${i#*=}
;;
v=*)
Version=${i#*=}
;;
d=*)
ftpline=${i#*=}
;;
t=*)
type=${i#*=}
;;
l=*)
lang=${i#*=}
;;
b=*)
Build=$(echo ${i#*=} | sed -e "s/_/ /g")
;;
i=*)
info_l=${i#*=}
;;
*)
;;
esac
done
#<----------------
#echo "^  Modell  ^  Firmware ^  Download ^  Annex ^  Sprache  ^  Datum  ^  Info  ^" > "./0/log_1"
ii="-"
iii="<p>-</p>"
[ "$info_l" == "" ] && info_l="-"
[ "$info_l" != "-" ] && ii="[[ $info_l | Info]]" && iii="<a href='$info_l'>Info</a>"
! [ -z "$Version" ] && echo "| $name | $Version  | [[$ftpline | Downlaod]] | $type | $lang | $Build | $ii  |" >> "./0/wiki.lst"

cat <<SETEOF >> ./0/firmware-download-liste.xhtml
				<tr class="ro2">
					<td class="ce2"><p>$name</p></td>
					<td class="ce8"><a>$Version</a></td>
					<td class="ce8"><a href="$ftpline">Download</a></td>
					<td class="ce8"><p>$type</p></td>
					<td class="ce8"><p>$lang</p></td>
					<td class="ce8"><p>$Build</p></td>
					<td class="ce8">$iii</td>
				</tr>
SETEOF
done < "./0/log_s1"

#---
echo This list has been generated with /speed-to-fritz/$0. >> "./0/wiki.lst"
cat <<SETEOF >> ./0/firmware-download-liste.xhtml
		</table>
		<p>This list has been generated with /speed-to-fritz/$0.</p>
	</body>
</html>
SETEOF
#rm -f "./0/log_1"
#rm -f "./0/log_s"
#rm -f "./0/log_s1"
[ -d /mnt/win/firmware-download-liste ] && cp ./0/firmware-download-liste.xhtml /mnt/win/firmware-download-liste/firmware-download-liste.xhtml
[ -d /mnt/win/firmware-download-liste ] && cp ./0/wiki.lst /mnt/win/firmware-download-liste/wiki.lst
echo "--> output to: ./0/firmware-download-liste.xhtml, use this file on any webpage." 
echo "--> output to: ./0/wiki.lst, copy and past this file to the wiki." 
echo "Done ..."
sleep 10
exit 0
