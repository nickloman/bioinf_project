import pysam
import sys

samfile = pysam.Samfile(sys.argv[1], "r")
for rec in samfile:
	if rec.mate_is_unmapped:
		a = set(rec.seq)
		if len(a) == 1 and a.pop() == 'N':
			continue

		if rec.is_read1:
			pair = '1'
		else:
			pair = '2'
		print ">%s/%s\n%s" % (rec.qname, pair, rec.seq)

