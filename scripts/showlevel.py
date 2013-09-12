import sys

level = int(sys.argv[1])
for fn in sys.argv[2:]:
	print fn
	for ln in open(fn):
		tax, val = ln.rstrip().split("\t")
		taxa = tax.split("|")
		if len(taxa) == level:
			print "\t" + taxa[level-1], val

	

