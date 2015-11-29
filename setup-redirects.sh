#!/bin/sh
touch /tmp/index.html
while read path
do
	aws s3 cp --acl public-read /tmp/index.html s3://natalian/$path --website-redirect="http://natalian.org$(dirname ${path#archives})/"
done < redirects.txt
