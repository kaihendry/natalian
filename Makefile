INFILES = $(shell shopt -s globstar; for i in **/*.mdwn; do echo $$i; done)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/style.css $(OUTPUT)/index.rss $(OUTPUT)/index.atom

godeps:
	go get github.com/kaihendry/blog/header
	go get github.com/kaihendry/blog/index
	go get github.com/kaihendry/blog/feeds
	go get github.com/kaihendry/blog/footer

$(OUTPUT)/%/index.html: %.mdwn
	@mkdir -p $(shell dirname $@ || true) || true
	@header $< > $@
	@sed '/^\[\[/ d' $< | cmark >> $@
	@footer $< >> $@
	@gzip $@
	@mv $@.gz $@
	@echo $< '→' $@

$(OUTPUT)/index.atom:
	feeds
	@gzip -c index.atom > $@

$(OUTPUT)/index.rss:
	feeds
	@gzip -c index.rss > $@

$(OUTPUT)/index.html: all
	@index | gzip > $@

$(OUTPUT)/style.css: style.css
	@echo "AddEncoding gzip .html .css" > $(OUTPUT)/.htaccess
	@gzip -c style.css > $(OUTPUT)/style.css

watch:
	while ! inotifywait -r -e modify .; do make; done

upload: $(OUTPUT)/index.html $(OUTPUT)/style.css
	@s3cmd -c ~/.s3cfg-hsg sync --add-header 'Content-Encoding:gzip' -rr --delete-removed --cf-invalidate --cf-invalidate-default-index -P $(OUTPUT)/ s3://natalian.org/
	s3cmd -c ~/.s3cfg-hsg modify s3://natalian.org/style.css --mime-type="text/css"
	curl -I http://natalian.org.s3-website-ap-southeast-1.amazonaws.com/style.css


clean:
	@rm -rf $(OUTPUT) index.rss index.atom
