#!/usr/bin/env python3
# Copyright 2019 Collabora, Ltd.
# SPDX-License-Identifier: BSL-1.0
# Author: Ryan Pavlik <ryan.pavlik@collabora.com>
# Parses apt-cache policy output on Ubuntu and Debian to identify the release codename
# (e.g. xenial, stretch)

import re
import subprocess
import sys

ATTR = re.compile(r"(?P<char>[a-z])=(?P<val>[^,]+),?")
UBUNTU_AND_DEBIAN = set(('Ubuntu', 'Debian'))
def lineToDict(line):
    """Convert an apt-cache policy release line into a dictionary."""
    return {match.group('char'): match.group('val') for match in ATTR.finditer(line)}

def isDesired(d):
    """Identify if a dictionary describes a release line that can provide the codename."""
    return d.get('o') in UBUNTU_AND_DEBIAN and d.get('l') in UBUNTU_AND_DEBIAN and d.get('c') == 'main'

# Run apt-cache policy
result = subprocess.run(['apt-cache', 'policy'], stdout=subprocess.PIPE)

# Extract the "release" lines
release_lines = (x for x in result.stdout.decode(encoding='utf-8').split('\n') if "release" in x and "updates" not in x)

# Turn into dictionaries and filter
entries = (lineToDict(line) for line in release_lines)
filtered = (x for x in entries if isDesired(x))

# Identify the unique codenames - ideally there is only 1
codenames = set((x['n'] for x in filtered if 'n' in x))

if len(codenames) != 1:
    print(codenames)
    print("Didn't arrive at just a single codename!")
    sys.exit(1)

for c in codenames:
    print(c)
