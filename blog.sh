if test "$1"
then
	mkdir -p archives/$(date +%Y/%m/%d)
	vim archives/$(date +%Y/%m/%d)/$1
	git add archives/$(date +%Y/%m/%d)/$1
	echo archives/$(date +%Y/%m/%d)/$1
fi
