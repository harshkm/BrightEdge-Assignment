#!/usr/bin/env python3
import os

threshold=80

output = os.popen("df -Th /").readlines()
usage = int(output[1].split()[5].strip('%'))
print("1" if usage > threshold else "0")
