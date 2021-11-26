#!/usr/bin/env python3

with open('lvl5', 'rb') as f:
    bin = f.read()

fix = bytes([0x20,0x06,0x40,0x00])

print(f"before fix: {bin[0x540:0x544].hex()}")
fix_bin = bin[:0x540] + fix + bin[0x544:]
print(f"after fix: {fix_bin[0x540:0x544].hex()}")

with open('lvl5_fix', 'wb') as f:
    f.write(fix_bin)
