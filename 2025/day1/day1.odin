package main

import "core:bufio"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

DIAL_MAX :: 100

main :: proc() {
	current := 50
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
			current = (current + num) % DIAL_MAX
		} else if dir == 'L' {
			current = (current + DIAL_MAX - num) % DIAL_MAX
		}

		if current == 0 {
			leftAt0Count += 1
		}
	}

	fmt.printfln("answer: %d", leftAt0Count)
}
