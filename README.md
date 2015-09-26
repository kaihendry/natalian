# Kai's own suckless blog

Keeping it simple: <http://natalian.org.s3-website-ap-southeast-1.amazonaws.com/>

Uses a [Makefile](Makefile) like a sane project should !!

* <https://ikiwiki.info/ikiwiki/directive/meta/> which my source mdwn uses, uses `[[!meta field="value"]]`

# TODO

## Scraper / index / link friendly

I should try support these ridiculous <a href=http://ogp.me/><abbr title="Open
Graph">OG</abbr> elements</a> via
<https://developers.facebook.com/tools/debug/og/object/>, the most important probably being:

* description
* icon

Used by [reddit's media scraper](https://github.com/reddit/reddit/blob/master/r2/r2/lib/media.py) for one.

# Setup notes

	s3cmd mb s3://natalian.org
	s3cmd ws-create s3://natalian.org

# Tooling

I've created little [blogging tools with golang](https://github.com/kaihendry/blog)
