import sys

for ln in sys.stdin:
    cols = ln.rstrip().split(",")
    fields = cols[0].split(";")
    for n in range(0,10):
        try:
           print fields.pop(0) + "\t",
        except Exception:
           print "-" + "\t",
    print cols[1]

