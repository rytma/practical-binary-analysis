#!/usr/bin/env python3

with open('lvl3', 'rb') as f:
    bin = f.read()

s_textoff = 4480 + (64 * 14)
s_textofftype = s_textoff + 4


fixbin = bin[:7] + \
         bytes([0]) + \
         bin[8:18] + \
         bytes([0x3e]) + \
         bin[19:32] + \
         bytes([0x40,0x00,0x00,0x00,0x00,0x00,0x00,0x00]) + \
         bin[40:s_textofftype] + \
         bytes([0x1,0x00,0x00,0x00]) + \
         bin[s_textofftype+4:]

with open('lvl3_fix', 'wb') as f:
    f.write(fixbin)
