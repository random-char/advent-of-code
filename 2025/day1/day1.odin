package main

import "core:bufio"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

DIAL_MAX :: 100

main :: proc() {
	current := 50
	previous := 0
	dt: int
	passing0Count := 0
	leftAt0Count := 0

	f, err := os.open("./rotations")
	if err != nil {
		panic("this is embaraccing, failed to open file")
	}
	defer os.close(f)

	reader: bufio.Reader
	buffer: [1024]byte
	bufio.reader_init_with_buf(&reader, os.to_stream(f), buffer[:])
	defer bufio.reader_destroy(&reader)

	for {
		line, err := bufio.reader_read_string(&reader, '\n')
		if err != nil {
			break
		}

		if len(line) < 2 {
			panic("invalid format")
		}

		dir := line[0]
		num, ok := strconv.parse_int(strings.trim_right(line[1:], "\r\n"))
		if !ok {
			panic("failed to parse a number")
		}

		if dir == 'R' {
			dt = 1
		} else if dir == 'L' {
			dt = -1
		}

		passing0Count += num / DIAL_MAX
		num %= DIAL_MAX

		previous = current
		current = current + dt * num
		if num != 0 && previous != 0 && (current >= DIAL_MAX || current <= 0) {
			passing0Count += 1
		}
		current = (current + DIAL_MAX) % DIAL_MAX

		if current == 0 {
			leftAt0Count += 1
		}
	}

	fmt.printfln("answer part 1: %d", leftAt0Count)
	fmt.printfln("answer part 2: %d", passing0Count)
}
