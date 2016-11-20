INFILES = $(shell find . -name '*.mdwn' -type f)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
GZ = gzip --best
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/style.css $(OUTPUT)/index.rss $(OUTPUT)/index.atom $(OUTPUT)/sitemap.txt $(OUTPUT)/404.html $(OUTPUT)/stats.js

godeps:
	go get github.com/kaihendry/blog/header
	go get github.com/kaihendry/blog/index
	go get github.com/kaihendry/blog/feeds
	go get github.com/kaihendry/blog/footer

$(OUTPUT)/404.html: 404.html
	$(GZ) -c $< > $@

$(OUTPUT)/%/index.html: %.mdwn
	@mkdir -p $(@D)
	@header $< > $@
	@sed '/^\[\[/ d' $< | cmark >> $@
	@footer $< >> $@
	@$(GZ) $@
	@mv $@.gz $@
	@echo $< '→' $@

$(OUTPUT)/index.atom: $(LIST)
	feeds
	@$(GZ) -c index.atom > $@

$(OUTPUT)/stats.js: stats.js
	$(GZ) -c $< > $@

$(OUTPUT)/sitemap.txt: $(LIST)
	sitemap | $(GZ) > $@

$(OUTPUT)/index.rss: $(LIST)
	feeds
	@$(GZ) -c index.rss > $@

$(OUTPUT)/index.html: $(LIST) godeps
	@index | $(GZ) > $@

$(OUTPUT)/style.css: style.css
	@$(GZ) -c style.css > $(OUTPUT)/style.css

# http://natalian.s3-website-ap-southeast-1.amazonaws.com/
upload: $(OUTPUT)/index.html $(OUTPUT)/style.css
	@aws s3 website s3://natalian/ --index-document index.html --error-document 404.html
	@aws s3 sync --content-encoding gzip --size-only --exclude .htaccess --cache-control="max-age=86400" --storage-class STANDARD_IA --acl public-read $(OUTPUT)/ s3://natalian/
	@aws cloudfront create-invalidation --distribution-id E2AXSD6P2TRMEA --invalidation-batch "{ \"Paths\": { \"Quantity\": 1, \"Items\": [ \"/*\" ] }, \"CallerReference\": \"$(shell date +%s)\" }"

clean:
	@rm -rf $(OUTPUT) index.rss index.atom

.PHONY: setupredirects upload clean watch godeps
