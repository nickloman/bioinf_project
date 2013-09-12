import sys
import time
import subprocess
import select
import os

p = subprocess.Popen(sys.argv[1:], stdout=subprocess.PIPE, stdin=subprocess.PIPE)
lines = sys.stdin.read().split("\n")

to_read = [p.stdout]

while to_read:
    read_now, write_now, xlist = select.select(to_read, [], [])
    if read_now:
        data = os.read(p.stdout.fileno(), 1024)
        if not data:
            p.stdout.close()
            to_read = []
        else:
            print data,
            if 'MEGAN>' in data:
                 p.stdin.write(lines.pop(0) + '\n')
                 p.stdin.flush()
                 time.sleep(2)

p.stdout.close()
p.stdin.close()
