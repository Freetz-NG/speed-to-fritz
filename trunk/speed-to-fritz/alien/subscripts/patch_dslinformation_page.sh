#!/bin/bash
. $include_modpatch
echo "-- adjust tabs on dsl-information page ..."
DIRI="$(find ${1}/usr/www/ \( -name adsl.html -o -name dslsnrset.html -o -name atm.html -o -name bits.html -o -name overview.html -o -name feedback.html -o -name vdsl_profile.html \) -type f -print)"
for file_n in $DIRI; do
    [ "${file_n##*/}" == "dslsnrset.html" ] &&\
    sed -i -e 's|<li class="tabs_on"><div class="activtab">.*</div></li>|<li class="tabs_on"><div class="activtab">Annex A/B</div></li>|g' "$file_n"
    grep -q "uiDoSNRPage()" "$file_n" && \
    sed -i -e 's|<li><a href="javascript:uiDoSNRPage()">.*</a></li>|<li><a href="javascript:uiDoSNRPage()">Annex A/B</a></li>|g' "$file_n"
    grep -q "uiDoFeedbackPage()" "$file_n" && \
    sed -i -e "/uiDoFeedbackPage()/d" "$file_n"
    sed -i -e 's|<? if neq $var:Annex A|<? if neq A A|' "$file_n"
    grep -q "<? if neq A A" "$file_n" && echo2 "  removed SNR setting from file:${file_n##*/}"
  [ "${FORCE_DSL_MULTI_ANNEX}" != "y" ] && sed -i -e "/Annex A.B/d" "$file_n"
    grep -q "Annex A.B" "$file_n" && echo2 "    replaced tabtext Stoersicherheit with Annex A/B in file:${file_n##*/}"
done

exit 0
