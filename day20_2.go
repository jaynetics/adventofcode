package main

import (
	"fmt"
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

func (p1 particle) CollidesWith(p2 particle) bool {
	return p1.px == p2.px && p1.py == p2.py && p1.pz == p2.pz
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

	for i := 0; i < 100; i++ {
		particles = removeColliders(particles)
		for idx, _ := range particles {
			particles[idx].Move()
		}
	}

	fmt.Printf("Particles left: %d\n", len(particles))
}

func removeColliders(particles []particle) (result []particle) {
	for _, p := range particles {
		if !hasCollisions(p, particles) {
			result = append(result, p)
		}
	}
	return
}

func hasCollisions(p1 particle, otherParticles []particle) bool {
	for _, p2 := range otherParticles {
		if p1 != p2 && p1.CollidesWith(p2) {
			return true
		}
	}
	return false
}

func input() string {
	return `... paste input here ...`
}
