package main

import (
	"os"
	"text/template"
)

func main() {

	data := struct {
		Title string
	}{
		"Howdy",
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

	err = t.Execute(os.Stdout, data)

	if err != nil {
		panic(err)
	}

}
