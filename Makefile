.PHONY: all pdf html clean serve 

SOURCE=./content/*.adoc 
DESTINATION=dist
TEMPLATES=templates
CP=$(shell sh -c 'cygpath -w /usr/bin')/cp.exe
RM=$(shell sh -c 'cygpath -w /usr/bin')/rm.exe

all: html

pdf:
	asciidoctor-pdf -D ${DESTINATION}/pdf/ ${SOURCE} 

html:
	asciidoctor -D ${DESTINATION}/html/ -T ${TEMPLATES} -b html ${SOURCE}
	${CP} style.css ${DESTINATION}/html/style.css
	${CP} favicon.ico ${DESTINATION}/html/favicon.ico
	${CP} manifest.webmanifest ${DESTINATION}/html/manifest.webmanifest
	${CP} service-worker.js ${DESTINATION}/html/service-worker.js
	${CP} -r img ${DESTINATION}/html/img
	${CP} -r vendor ${DESTINATION}/html/vendor
	${CP} -r fonts ${DESTINATION}/html/fonts

clean:
	${RM} -rf ${DESTINATION}

serve: html
	npx browser-sync start --server dist/html --files "dist/html/**/*" --no-notify --no-ui --port 3201 

