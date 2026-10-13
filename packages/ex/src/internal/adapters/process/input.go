package process

import (
	"context"
	"fmt"
	"os"

	"golang.org/x/sys/unix"
)

// Input makes the CLI's exclusively owned standard input cancellation-aware.
// Polling happens on the caller's goroutine, so canceling a guided prompt cannot
// leave a reader worker behind. It neither closes nor changes the caller's file.
type Input struct {
	Context context.Context
	File    *os.File
}

// Read waits for input or cancellation. The file must have a single reader.
func (in Input) Read(p []byte) (int, error) {
	if len(p) == 0 {
		return 0, nil
	}
	descriptors := []unix.PollFd{{Fd: int32(in.File.Fd()), Events: unix.POLLIN}}
	for {
		if err := in.Context.Err(); err != nil {
			return 0, err
		}
		ready, err := unix.Poll(descriptors, 100)
		if err == unix.EINTR {
			continue
		}
		if err != nil {
			return 0, fmt.Errorf("wait for input: %w", err)
		}
		if ready == 0 {
			continue
		}
		if descriptors[0].Revents&unix.POLLNVAL != 0 {
			return 0, os.ErrClosed
		}
		return in.File.Read(p)
	}
}
