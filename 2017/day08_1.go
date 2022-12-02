package main

import (
	"fmt"
	"math"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	pattern, _ := regexp.Compile(`(\w+) (\w+) (-?\d+) if (\w+) (\S+) (-?\d+)`)
	register := make(map[string]int)

	for _, line := range strings.Split(input(), "\n") {
		result := pattern.FindStringSubmatch(line)
		target := result[1]
		change := result[2]
		amt, _ := strconv.Atoi(result[3])
		cmpVar := result[4]
		cmpOpr := result[5]
		cmp, _ := strconv.Atoi(result[6])

		if conditionMet(register[cmpVar], cmpOpr, cmp) {
			update(register, target, change, amt)
		}
	}

	printMax(register)
}

func conditionMet(value int, comparison string, comparandum int) bool {
	switch comparison {
	case ">":
		return value > comparandum
	case "<":
		return value < comparandum
	case "<=":
		return value <= comparandum
	case ">=":
		return value >= comparandum
	case "!=":
		return value != comparandum
	case "==":
		return value == comparandum
	default:
		return false
	}
}

func update(register map[string]int, target string, change string, amount int) {
	newVal := register[target]
	if change == "inc" {
		newVal = newVal + amount
	} else {
		newVal = newVal - amount
	}
	register[target] = newVal
}

func printMax(register map[string]int) {
	var maxKey string
	maxVal := math.MinInt64

	for key, value := range register {
		if value > maxVal {
			maxKey = key
			maxVal = value
		}
	}

	fmt.Printf("The highest value is now '%s' at %d\n", maxKey, maxVal)
}

func input() string {
	return `... paste input here w/o indentation ...`
}
