if test "$1"
then
	mkdir -p $(date +%Y/%m/%d)
	vim $(date +%Y/%m/%d)/$1
	git add $(date +%Y/%m/%d)/$1
	echo $(date +%Y/%m/%d)/$1
fi
