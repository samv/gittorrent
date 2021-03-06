
txt:	rfc
	xml2rfc rfc.xml

PAGER=less -B

man:	rfc
	xml2rfc rfc.xml rfc.nr
	nroff -man rfc.nr | $(PAGER)

html:	rfc
	xml2rfc rfc.xml rfc.html
	perl -npi~ -e 's{(.*header.*>)(&nbsp;)}{$$x++?"$$1$$2":"$$1 (src rev ".substr(`git-rev-parse HEAD`,0,8).")"}e' rfc.html

publish: html
	scp rfc.html `cat .publish_target`

rfc:	rfc.xml refs.stamp

refs.stamp:
	-mkdir refs
	grep ENTITY.*RFC.*xml rfc.xml | sed "s/.*'\(.*\)'.*/\1/" | \
	while read fn;		\
	do			\
	    bn=`basename $$fn`;	\
	    wget -O $$fn http://xml.resource.org/public/rfc/bibxml/$$bn; \
	done
	touch refs.stamp
