touch /tmp/index.html
while read path
do
	echo aws --profile hsgpower s3 cp --acl public-read /tmp/index.html s3://natalian.org/$path --website-redirect="http://natalian.org/${path#archives}"
done < redirects.txt
