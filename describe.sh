test -f $1 || exit
echo '[[!meta description=""]]'|cat - $1 > /tmp/out && mv /tmp/out $1
vim "+call cursor(1, 22)" $1
