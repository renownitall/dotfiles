#!/usr/bin/env python3
import sys
import time
import termios
import tty
import select


def main():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)  # remember current TTY settings
    start = time.time()
    try:
        tty.setcbreak(fd)  # no echo, no line buffering; Ctrl+C still works
        while True:
            elapsed = time.time() - start
            h = int(elapsed // 3600)
            m = int((elapsed % 3600) // 60)
            s = int(elapsed % 60)
            sys.stdout.write(f"\rElapsed: {h:02d}:{m:02d}:{s:02d}\033[K")
            sys.stdout.flush()
            # Wait up to 1s for input; if a key arrives, consume & discard it
            r, _, _ = select.select([sys.stdin], [], [], 1.0)
            if r:
                sys.stdin.read(1)  # swallow the keystroke so it can't queue
    except KeyboardInterrupt:
        pass  # Ctrl+C, fall through to cleanup
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)  # always restore TTY
        sys.stdout.write("\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
