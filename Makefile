INFILES = $(shell shopt -s globstar; for i in **/*.mdwn; do echo $$i; done)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/style.css

godeps:
	go get github.com/kaihendry/blog/header
	go get github.com/kaihendry/blog/index

$(OUTPUT)/%/index.html: %.mdwn
	@mkdir -p $(shell dirname $@ || true) || true
	@header $< > $@
	@sed '/^\[\[/ d' $< | cmark >> $@
	@./footer.sh $< >> $@
	@gzip $@
	@mv $@.gz $@
	@echo $< '→' $@

$(OUTPUT)/index.html: all
	@index | gzip > $@

$(OUTPUT)/style.css: style.css
	@echo "AddEncoding gzip .html .css" > $(OUTPUT)/.htaccess
	@gzip -c style.css > $(OUTPUT)/style.css

watch:
	while ! inotifywait -r -e modify .; do make; done

upload: $(OUTPUT)/index.html $(OUTPUT)/style.css
	@s3cmd -c ~/.s3cfg-hsg sync --add-header 'Content-Encoding:gzip' -rr --delete-removed -P $(OUTPUT)/ s3://natalian.org/

clean:
	@rm -rf $(OUTPUT)
