package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strings"
	"text/template"
)

type Post struct {
	Title string
}

var p Post

func main() {
	flag.Parse()
	mdwn := flag.Arg(0)
	file, err := os.Open(mdwn)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer file.Close()

	reader := bufio.NewReader(file)
	scanner := bufio.NewScanner(reader)

	for scanner.Scan() {
		line := scanner.Text()
		if !strings.Contains(line, "[[!meta") {
			break
		}
		//fmt.Println(line)

		item := strings.TrimPrefix(line, `[[!meta `)
		splitItem := strings.Split(item, "=\"")
		splitItem[1] = strings.TrimSuffix(splitItem[1], "\" ]]")
		//fmt.Println(splitItem[0], splitItem[1])
		if splitItem[0] == "title" {
			p = Post{Title: splitItem[1]}
		}

	}

	t, err := template.New("foo").Parse(`<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<link href="/style.css" rel="stylesheet">
<meta name=viewport content="width=device-width, initial-scale=1">
<title>{{ .Title }}</title>
</head>
<body>
`)

	if err != nil {
		panic(err)
	}

	err = t.Execute(os.Stdout, p)

	if err != nil {
		panic(err)
	}

}
