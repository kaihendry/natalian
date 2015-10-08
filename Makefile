INFILES = $(shell find . -name '*.mdwn' -type f)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
GZ = gzip --best
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/style.css $(OUTPUT)/index.rss $(OUTPUT)/index.atom $(OUTPUT)/404.html $(OUTPUT)/stats.js

godeps:
	go get github.com/kaihendry/blog/header
	go get github.com/kaihendry/blog/index
	go get github.com/kaihendry/blog/feeds
	go get github.com/kaihendry/blog/footer

$(OUTPUT)/404.html: 404.html
	$(GZ) -c $< > $@

$(OUTPUT)/%/index.html: %.mdwn
	@mkdir -p $(shell dirname $@ || true) || true
	@header $< > $@
	@sed '/^\[\[/ d' $< | cmark >> $@
	@footer $< >> $@
	@$(GZ) $@
	@mv $@.gz $@
	@echo $< '→' $@

$(OUTPUT)/index.atom:
	feeds
	@$(GZ) -c index.atom > $@

$(OUTPUT)/stats.js: stats.js
	$(GZ) -c $< > $@

$(OUTPUT)/index.rss:
	feeds
	@$(GZ) -c index.rss > $@

$(OUTPUT)/index.html: $(LIST)
	@index | $(GZ) > $@

$(OUTPUT)/style.css: style.css
	@echo "AddEncoding $(GZ) .html .css .js .rss .atom" > $(OUTPUT)/.htaccess
	@$(GZ) --best -c style.css > $(OUTPUT)/style.css

upload: $(OUTPUT)/index.html $(OUTPUT)/style.css
	@aws --profile hsgpower s3 website s3://natalian.org/ --index-document index.html --error-document 404.html
	@aws --profile hsgpower s3 sync --content-encoding gzip --size-only --exclude .htaccess --cache-control="max-age=86400" --storage-class REDUCED_REDUNDANCY --acl public-read $(OUTPUT)/ s3://natalian.org/
	@aws --profile hsgpower cloudfront create-invalidation --distribution-id E306XHF91A6XT0 --invalidation-batch "{ \"Paths\": { \"Quantity\": 1, \"Items\": [ \"/*\" ] }, \"CallerReference\": \"$(shell date +%s)\" }"

clean:
	@rm -rf $(OUTPUT) index.rss index.atom

.PHONY: setupredirects upload clean watch godeps
