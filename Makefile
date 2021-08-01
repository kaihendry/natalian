INFILES = $(shell find . -name '*.mdwn' -type f)
OUTPUT = /tmp/www/natalian
OUTFILES = $(INFILES:.mdwn=/index.html)
LIST=$(addprefix $(OUTPUT)/, $(OUTFILES))

all: $(LIST) $(OUTPUT)/index.html $(OUTPUT)/index.rss $(OUTPUT)/index.atom $(OUTPUT)/sitemap.txt $(OUTPUT)/404.html $(OUTPUT)/stats.js $(OUTPUT)/thank-you.html $(OUTPUT)/oh-no.html

godeps:
	go get github.com/kaihendry/blog/...

$(OUTPUT)/404.html: 404.html
	cat $< > $@

$(OUTPUT)/oh-no.html: oh-no.html
	cat $< > $@

$(OUTPUT)/thank-you.html: thank-you.html
	cat $< > $@

$(OUTPUT)/%/index.html: %.mdwn
	@mkdir -p $(@D)
	@header $< > $@
	@sed '/^\[\[/ d' $< | cmark --unsafe >> $@
	@footer $< >> $@
	@echo $< '→' $@

$(OUTPUT)/index.atom: $(LIST)
	feeds
	cat index.atom > $@

$(OUTPUT)/stats.js: stats.js
	cat $< > $@

$(OUTPUT)/sitemap.txt: $(LIST)
	sitemap > $@

$(OUTPUT)/index.rss: $(LIST)
	feeds
	cat index.rss > $@

$(OUTPUT)/index.html: $(LIST)
	@index > $@

# http://natalian.s3-website-ap-southeast-1.amazonaws.com/
upload: $(OUTPUT)/index.html
	@aws s3 --profile mine website s3://natalian/ --index-document index.html --error-document 404.html
	@aws s3 --profile mine sync --exclude .htaccess --cache-control="max-age=86400" --storage-class STANDARD_IA --acl public-read $(OUTPUT)/ s3://natalian/
	@aws --profile mine cloudfront create-invalidation --distribution-id E2AXSD6P2TRMEA --invalidation-batch "{ \"Paths\": { \"Quantity\": 1, \"Items\": [ \"/*\" ] }, \"CallerReference\": \"$(shell date +%s)\" }"

clean: godeps
	@rm -rf $(OUTPUT) index.rss index.atom

.PHONY: setupredirects upload clean watch godeps
