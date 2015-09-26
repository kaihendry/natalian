INFILES = $(shell shopt -s globstar; for i in **/*.mdwn; do echo $$i; done)
OUTPUT = /srv/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
GZ = gzip --best
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/style.css $(OUTPUT)/index.rss $(OUTPUT)/index.atom $(OUTPUT)/404.html

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

$(OUTPUT)/index.rss:
	feeds
	@$(GZ) -c index.rss > $@

$(OUTPUT)/index.html: all
	@index | $(GZ) > $@

$(OUTPUT)/style.css: style.css
	@echo "AddEncoding $(GZ) .html .css" > $(OUTPUT)/.htaccess
	@$(GZ) --best -c style.css > $(OUTPUT)/style.css

upload: $(OUTPUT)/index.html $(OUTPUT)/style.css
	@aws --profile hsgpower s3 website s3://natalian.org/ --index-document index.html --error-document 404.html
	@aws --profile hsgpower s3 sync --content-encoding gzip --size-only --storage-class REDUCED_REDUNDANCY --acl public-read $(OUTPUT)/ s3://natalian.org/
	@#curl -I http://natalian.org.s3-website-ap-southeast-1.amazonaws.com/style.css
	@aws --profile hsgpower cloudfront create-invalidation --distribution-id E306XHF91A6XT0 --invalidation-batch "{ \"Paths\": { \"Quantity\": 1, \"Items\": [ \"/*\" ] }, \"CallerReference\": \"$(shell date +%s)\" }"

clean:
	@rm -rf $(OUTPUT) index.rss index.atom

.PHONY: setupredirects upload clean watch godeps
