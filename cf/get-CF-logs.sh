#!/bin/bash
aws s3 --profile mine sync --delete s3://hendry-cf-logs/natalian logs
if ! hash goaccess
then
	echo Install https://goaccess.io/
	exit 1
fi

for i in logs/*.gz; do zcat < $i; done | goaccess --enable-panel=REFERRERS --log-format=CLOUDFRONT -o report.html
