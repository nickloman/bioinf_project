from Bio import SeqIO
import sys

def stats(seq_name, fh):
    contig_lengths = []
    for rec in SeqIO.parse(fh, "fasta"):
        contig_lengths.append(len(rec))

    contig_lengths.sort(reverse=True)

    n_vals = {0.5 : 0, 0.75 : 0, 0.9 : 0}

    total = sum(contig_lengths)
    for key in n_vals.keys():
        l = 0
        for n in contig_lengths:
            l += n
            if l > total * key:
                n_vals[key] = n
                break

    print "%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d" % (seq_name,
                                      len(contig_lengths),
                                      min(contig_lengths),
                                      max(contig_lengths),
                                      sum(contig_lengths),
                                      sum(contig_lengths) / len(contig_lengths),
                                      n_vals[0.5],
                                      n_vals[0.75],
                                      n_vals[0.9])

print "Seq\tN\tMin\tMax\tTotal\tAvg\tN50\tN75\tN90"
if sys.argv[1:]:
    for fn in sys.argv[1:]:
        stats(fn, open(fn))
else:
    stats("stdin", sys.stdin)

