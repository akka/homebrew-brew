#!/usr/bin/env python3
import os
import re

import requests as req
import subprocess
from sys import platform

scriptlines = {
    "version": ["16",'    version \\"{0}\\"'],
    "darwinamd64": ["24", '            sha256 \\"{0}\\"'],
    "darwinarm64": ["27", '            sha256 \\"{0}\\"'],
    "linuxamd64": ["33", '        sha256 \\"{0}\\"']
}

def parseLine(line):
    elems = line.split(' ')
    sha = elems[0].strip()
    elems = elems[2].split('_')
    os = elems[1]
    proc = elems[2]
    version = elems[3].removesuffix('.tar.gz')
    return {
        "sha": sha,
        "os": os,
        "processor": proc,
        "version": version
    }

version = os.environ.get('CLI_VERSION', 'latest')
if version != 'latest' and not re.fullmatch(r'[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?', version):
    raise ValueError('Invalid CLI version')

url = f'https://downloads.akka.io/{version}/akka_checksums.txt'
resp = req.get(url)
resp.raise_for_status()

lines = resp.text.splitlines()

sedCommand = "sed"
if platform == "darwin":
    sedCommand = "gsed"

for line in lines:
    d = parseLine(line)
    if d['os'] + d['processor'] in scriptlines:
        ## Update the SHA
        ln = scriptlines[d['os'] + d['processor']][0]
        ct = scriptlines[d['os'] + d['processor']][1].format(d['sha'])
        subprocess.call(["{2} -i \"{0}s/.*/{1}/\" Formula/akka.rb".format(ln, ct, sedCommand)], shell=True)
        ## Update the version
        ln = scriptlines['version'][0]
        ct = scriptlines['version'][1].format(d['version'])
        subprocess.call(["{2} -i \"{0}s/.*/{1}/\" Formula/akka.rb".format(ln, ct, sedCommand)], shell=True)
