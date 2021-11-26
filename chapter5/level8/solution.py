#!/usr/bin/env python3

with open('lvl8', 'r') as f:
    content = f.read()

conv = ''
for x in content:
    if x.isalpha():
        if x.islower():
            conv += '0'
        if x.isupper():
            conv += '1'

assert len(conv) % 8 == 0

hx = ''
for x in range(0, len(conv), 8):
    hx += format(int(conv[x:x+8],2), '#04x')[2:]

with open('lvl8_bin','wb') as f:
    f.write(bytes.fromhex(hx))
