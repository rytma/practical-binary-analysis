#!/usr/bin/env python3

import sys
from PIL import Image

img = Image.open('lvl8_bin')

extracted = ''
pixels = img.load()

for i in range(0, img.height):
    for j in range(0, img.width):
        r,g,b = pixels[i,j]
        extracted += bin(r)[-1]
        extracted += bin(g)[-1]
        extracted += bin(b)[-1]

assert len(extracted) % 8 == 0

hx = ''
for x in range(0,len(extracted),8):
    hx += format(int(extracted[x:x+8],2),"#04x")[2:]

binary = bytes.fromhex(hx)

with open('lvl8_steg', 'wb') as f:
    f.write(binary)
