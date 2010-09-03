#!/bin/bash
 . $include_modpatch
 echo "-- applying Button for sending fonbook ..."
for DIR in ${OEMLIST}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML/de/fon
    if [ -d ${DSTI} ] ; then


  DIRI="usr/www/${HTML}/de/home" 
  if ! [ -f "$1"/$DIRI/fondevices.html ]; then
   DIRI="usr/www/${HTML}/de/fon"
     #link for booksend
     if ! [ -f "$1"/$DIRI/fonbuch.js ]; then 
        # generate linke files -->
	DSTF="$1/$DIRI/buchsend.frm"
	touch "${DSTF}"
	cat << 'EOF' >> "${DSTF}"
<? include ../html/$var:lang/home/buchsend.frm ?>
EOF
	chmod 755 "${DSTF}"
	DSTF="$1/$DIRI/buchsend.html"
	touch "${DSTF}"
	cat << 'EOF' >> "${DSTF}"
<? include ../html/$var:lang/home/buchsend.html ?>
EOF
	chmod 755 "${DSTF}"
	DSTF="$1/$DIRI/buchsend.js"
	touch "${DSTF}"
	cat << 'EOF' >> "${DSTF}"
<? include ../html/$var:lang/home/buchsend.js ?>
EOF
	chmod 755 "${DSTF}"
	# generate linke files <--
    fi
  fi
#------------------------------------------------------------------
sed -i -e "/<\/script>/i \
function uiDoSendBook() {\n\jslGoTo(\"<? print \$var:menu ?>\", \"buchsend\");\n}" "$1/$DIRI/fonbuch.js"

if [ $avm_Lang = "de" ]; then
sed -i -e "/div class=\"forebuttons/i \
<div class=\"backdialog\" <div class=\"ecklm\"><div class=\"eckrm\"><div class=\"ecklb\"><div class=\"eckrb\"><div class=\"foredialog\">\n\
<p class=\"mb5\">Das Telefonbuch kann an Schnurlostelefone gesendet werden.<\/p>\n\
<input type=\"button\" value=\"Telefonbuch senden\" onclick=\"uiDoSendBook()\" class=\"Pushbutton\" style=\"width:180px;\">\n\
<div style=\"text-align: right;\">\n\<\/div>\n\<\/div><\/div><\/div><\/div><\/div><\/div>" "$1/$DIRI/fonbuch.html" 

# echo "<? setvariable var:TextSendBook 'Telefonbuch senden' ?>" >>"$1/$DIRI/fonbuch.inc"
# echo "<? setvariable var:TextSendHBook 'Sie können die Telefonbucheinträge an ein Schnurlostelefon senden.' ?>" >>"$1/$DIRI/fonbuch.inc"
else
sed -i -e "/div class=\"forebuttons/i \
<div class=\"backdialog\" <div class=\"ecklm\"><div class=\"eckrm\"><div class=\"ecklb\"><div class=\"eckrb\"><div class=\"foredialog\">\n\
<p class=\"mb5\">You can transfere the phonebook to the cellphones.<\/p>\n\
<input type=\"button\" value=\"Send phonebook\" onclick=\"uiDoSendBook()\" class=\"Pushbutton\" style=\"width:180px;\">\n\
<div style=\"text-align: right;\">\n\<\/div>\n\<\/div><\/div><\/div><\/div><\/div><\/div>" "$1/$DIRI/fonbuch.html" 
# echo "<? setvariable var:TextSendBook 'Send phonebook' ?>" >>"$1/$DIRI/fonbuch.inc"
# echo "<? setvariable var:TextSendHBook 'You can transfere the phonebook to the cellphones.' ?>" >>"$1/$DIRI/fonbuch.inc"
fi

#relpace in buchsend.html

#diable chack of falled handsets
sed -i -e '/<option value="$0"><script type="/d' "$1/$DIRI/buchsend.html"
#still do a warning
sed -i -e '/<? if eq $2 1 `/i\
<option value="$0"><script type="text\/javascript">document.write("<? query dect:settings\/Handset$0\/Name ?>");<\/script><\/option>' "$1/$DIRI/buchsend.html"
sed -i -e 's| <? if neq $var:handsetfound 1 `disabled` ?>||' "$1/$DIRI/buchsend.html"

#------------------------------------------------------------------
  fi
done
