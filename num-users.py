#!/usr/bin/env python

import json

with open('/home/minecraft/minecraft/map/pigmap/markers.json', 'r') as f:
    markers = json.load(f)

print len(markers) - 1
