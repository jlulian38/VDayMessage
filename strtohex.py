#!/usr/bin/python

import sys
import binascii

n=2
line = binascii.b2a_hex(sys.argv[1])
output = [line[i:i+n] for i in range(0, len(line), n)]

f = open(sys.argv[2],'w')
f.write("\n".join(output))

