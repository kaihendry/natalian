INFILES = $(shell shopt -s globstar; for i in **/*.mdwn; do echo $$i; done)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST)

$(OUTPUT)/%/index.html: %.mdwn
	@echo $< '→' $@
	@mkdir -p $(shell dirname $@ || true) || true
	@cmark $< > $@

index: all
	go run main.go > $(OUTPUT)/index.html

watch:
	while ! inotifywait -e modify *.mdwn; do make; done

clean:
	rm -rf $(OUTPUT)
