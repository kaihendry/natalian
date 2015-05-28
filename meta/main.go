package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func getKey(key string, mdwn string) (value string) {
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
		fmt.Println(line)

		item := strings.TrimPrefix(line, `[[!meta `)
		splitItem := strings.Split(item, "=\"")
		splitItem[1] = strings.TrimSuffix(splitItem[1], "\" ]]")

		if splitItem[0] == key {
			return splitItem[1]
		}

	}
	return ""
}

func main() {
	title := getKey("title", "test.dat")
	fmt.Println("Title:", title)
}
