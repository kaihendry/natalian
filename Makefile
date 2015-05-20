INFILES = $(shell shopt -s globstar; for i in **/*.mdwn; do echo $$i; done)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html

$(OUTPUT)/%/index.html: %.mdwn
	@echo $< '→' $@
	@mkdir -p $(shell dirname $@ || true) || true
	@cmark $< > $@

$(OUTPUT)/index.html: all main.go
	go run main.go > $(OUTPUT)/index.html

watch:
	while ! inotifywait -r -e modify .; do make; done

upload: $(OUTPUT)/index.html
	s3cmd sync -F -rr --delete-removed -P $(OUTPUT)/ s3://natalian.org/

clean:
	rm -rf $(OUTPUT)
