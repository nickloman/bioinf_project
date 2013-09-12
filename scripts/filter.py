import sys

def read_tax(fn):
	d = {}
	for ln in open(fn):
		path, count = ln.rstrip().split("\t")
		d[path] = count
	return d

exclude = set(read_tax(sys.argv[1]).keys())

for fn in sys.argv[2:]:
	print fn
	tax = read_tax(fn)
	x = set(tax.keys()) - exclude
	for k in x:
		print k, tax[k]


