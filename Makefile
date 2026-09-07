.PHONY: all pdf html clean serve 

SOURCE=./content/*.adoc 
DESTINATION=dist
TEMPLATES=templates
CP=$(shell sh -c 'cygpath -w /usr/bin')/cp.exe
RM=$(shell sh -c 'cygpath -w /usr/bin')/rm.exe

all: pdf html

pdf:
	asciidoctor-pdf -D ${DESTINATION}/pdf/ ${SOURCE} 

html:
	asciidoctor -a source-highlighter=rouge -D ${DESTINATION}/html/ -T ${TEMPLATES} -b html ${SOURCE}
	${CP} style.css ${DESTINATION}/html/style.css
	${CP} rouge.css ${DESTINATION}/html/rouge.css
	${CP} favicon.ico ${DESTINATION}/html/favicon.ico
	${CP} -r fonts ${DESTINATION}/html/fonts

clean:
	${RM} -rf ${DESTINATION}

serve: html
	npx browser-sync start --server ${DESTINATION}/html --files "${DESTINATION}/html/**/*" --no-notify

