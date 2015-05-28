cat <<EOF
<footer>
<p>$(wc -w < $1) words</p>
<p><a href=https://github.com/kaihendry/natalian/blob/master/$1>Source</a></p>
</footer>
</body>
</html>
EOF
