package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	file, err := os.Open("./file.dat")

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
		fmt.Println(splitItem[0], splitItem[1])

	}
}
