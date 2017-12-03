package main

import (
	"fmt"
	"math"
	"regexp"
	"strconv"
	"strings"
)

type particle struct {
	px int
	py int
	pz int
	vx int
	vy int
	vz int
	ax int
	ay int
	az int
}

func (p *particle) Move() {
	p.vx += p.ax
	p.vy += p.ay
	p.vz += p.az
	p.px += p.vx
	p.py += p.vy
	p.pz += p.vz
}

func (p particle) Distance() int {
	dx := p.px
	dy := p.py
	dz := p.pz
	if dx < 0 {
		dx = -dx
	}
	if dy < 0 {
		dy = -dy
	}
	if dz < 0 {
		dz = -dz
	}
	return dx + dy + dz
}

func main() {
	lines := strings.Split(input(), "\n")
	pattern, _ := regexp.Compile(`(-?\d+),(-?\d+),(-?\d+).*<(-?\d+),(-?\d+),(-?\d+).*<(-?\d+),(-?\d+),(-?\d+)`)
	particles := make([]particle, 0, len(lines))

	for _, line := range lines {
		result := pattern.FindStringSubmatch(line)
		px, _ := strconv.Atoi(result[1])
		py, _ := strconv.Atoi(result[2])
		pz, _ := strconv.Atoi(result[3])
		vx, _ := strconv.Atoi(result[4])
		vy, _ := strconv.Atoi(result[5])
		vz, _ := strconv.Atoi(result[6])
		ax, _ := strconv.Atoi(result[7])
		ay, _ := strconv.Atoi(result[8])
		az, _ := strconv.Atoi(result[9])
		particles = append(particles, particle{px, py, pz, vx, vy, vz, ax, ay, az})
	}

	for i := 0; i < 1000; i++ {
		for idx, _ := range particles {
			particles[idx].Move()
		}
	}

	minDist := math.MaxInt64
	minDistPartIdx := 0
	for i, p := range particles {
		partDist := p.Distance()
		if partDist < minDist {
			minDist = partDist
			minDistPartIdx = i
		}
	}

	fmt.Printf("Particle with minimum distance: %d\n", minDistPartIdx)
}

func input() string {
	return `... paste input here ...`
}
