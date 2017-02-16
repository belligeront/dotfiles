package main

import (
	"bytes"
	"fmt"
)

func main() {
	fmt.Printf("sum(99,35,32) = %+v\n", sum(99, 35, 32))
}

func sum(vals ...int) int {
	total := 0
	for _, val := range vals {
		total += val
	}
	return total
}

var buf bytes.Buffer
