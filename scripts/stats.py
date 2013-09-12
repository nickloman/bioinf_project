import sys
import subprocess

for label in sys.argv[1:]:
    human_aligned = int(open(label + ".wc").read().rstrip())
    other = int(subprocess.check_output(['wc', '-l', label + '.sam']).split(" ")[0])
    print label, human_aligned, other, 100.0 / (human_aligned+other) * human_aligned
