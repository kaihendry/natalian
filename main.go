package main

import (
	"fmt"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"text/template"
	"time"
)

type Post struct {
	PostDate time.Time
	URL      string
	Title    string
}

type Posts struct {
	Posts []Post
}

func (p Posts) Len() int {
	return len(p.Posts)
}

func (p Posts) Less(i, j int) bool {
	return p.Posts[i].PostDate.Before(p.Posts[j].PostDate)
}

func (p Posts) Swap(i, j int) {
	p.Posts[i], p.Posts[j] = p.Posts[j], p.Posts[i]
}

var p []Post

func visit(mdwn string, f os.FileInfo, err error) error {
	if !f.IsDir() {
		//fmt.Printf("Visiting: %s\n", mdwn)

		if filepath.Ext(mdwn) == ".mdwn" {

			fName := filepath.Base(mdwn)
			extName := filepath.Ext(mdwn)
			bName := fName[:len(fName)-len(extName)]
			url := fmt.Sprintf("/%s/", path.Join(filepath.Dir(mdwn), bName))
			title := strings.Replace(bName, "_", " ", -1)

			var a, b, c int
			fmt.Sscanf(mdwn, "archives/%d/%d/%d/", &a, &b, &c)
			date := fmt.Sprintf("%d-%02d-%02d", a, b, c)
			t, err := time.Parse("2006-01-02", date)
			//fmt.Println("Date:", t)
			if err != nil {
				panic(err)
			}

			//fmt.Println("Title:", title)
			//fmt.Println("URL:", url)
			p = append(p, Post{PostDate: t, URL: url, Title: title})

		} else {
			fmt.Fprintln(os.Stderr, "Skipping", mdwn)
		}

	}
	return nil
}

func main() {

	currentYear := "1900"

	funcMap := template.FuncMap{
		"newYear": func(t string) bool {
			if t == currentYear {
				return false
			} else {
				currentYear = t
				return true
			}
		},
	}

	err := filepath.Walk("archives", visit)
	if err != nil {
		panic(err)
	}

	//fmt.Fprintln(os.Stderr, p)

	posts := Posts{p}
	sort.Sort(sort.Reverse(posts))
	t, err := template.New("foo").Funcs(funcMap).Parse(`<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<link href="/style.css" rel="stylesheet">
<title>Kai Hendry's blog</title>
</head>
<body>

{{ range $i,$e := . }}
{{ if newYear (.PostDate.Format "2006")}}
{{ if gt $i 0 }}</ol>{{end}}
<h1>{{ .PostDate.Format "2006" }}</h1>
<ol>{{ end }}
<li><time datetime="{{ .PostDate.Format "2006-01-02" }}">{{ .PostDate.Format "Jan 2" }}</time>&raquo;<a href="{{ .URL }}">{{ .Title }}</a></li>{{end}}
</ol>
<p><a href=https://github.com/kaihendry/natalian/blob/mk/Makefile>Generated with a Makefile</a> and a piece of <a href=https://github.com/kaihendry/natalian/blob/mk/main.go>Golang</a></p>
</body>
</html>
`)

	if err != nil {
		panic(err)
	}

	err = t.Execute(os.Stdout, p)

	if err != nil {
		panic(err)
	}

}
