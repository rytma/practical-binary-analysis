#!/usr/bin/env python3

with open('lvl3', 'rb') as f:
    binary = f.read()


class E_IDENT(object):
    def __init__(self, e_ident):
        self.EI_MAGIC = e_ident[:4]
        self.EI_CLASS = e_ident[4]
        self.EI_DATA = e_ident[5]
        self.EI_VERSION = e_ident[6]
        self.EI_OSABI = e_ident[7]
        self.EI_ABIVERSION = e_ident[8]
        self.EI_PAD = e_ident[9:]
    def get(self):
        return self.EI_MAGIC + bytes([self.EI_CLASS, self.EI_DATA,
               self.EI_VERSION, self.EI_OSABI, self.EI_ABIVERSION]) + \
               self.EI_PAD

class Elf64_Ehdr(object):
    def __init__(self, binary):
        self.e_ident = E_IDENT(binary[:16])
        self.e_type = binary[16:18]
        self.e_machine = binary[18:20]
        self.e_version = binary[20:24]
        self.e_entry = binary[24:32]
        self.e_phoff = binary[32:40]
        self.e_shoff = binary[40:48]
        self.e_flags = binary[48:52]
        self.e_ehsize = binary[52:54]
        self.e_phentsize = binary[54:56]
        self.e_phnum = binary[56:58]
        self.e_shentsize = binary[58:60]
        self.e_shnum = binary[60:62]
        self.e_shstrndx = binary[62:64]
    def get(self):
        return self.e_ident.get() + self.e_type + self.e_machine + \
               self.e_version + self.e_entry + self.e_phoff + \
               self.e_shoff + self.e_flags + self.e_ehsize + \
               self.e_phentsize + self.e_phnum + self.e_shentsize + \
               self.e_shnum + self.e_shstrndx

class Elf64_Shdr(object):
    def __init__(self, section):
        self.sh_name = section[:4]
        self.sh_type = section[4:8]
        self.sh_flags = section[8:16]
        self.sh_addr = section[16:24]
        self.sh_offset = section[24:32]
        self.sh_size = section[32:40]
        self.sh_link = section[40:44]
        self.sh_info = section[44:48]
        self.sh_addralign = section[48:56]
        self.sh_entsize = section[56:64]
    def get(self):
        return self.sh_name + self.sh_type + self.sh_flags + \
               self.sh_addr + self.sh_offset + self.sh_size + \
               self.sh_link + self.sh_info + self.sh_addralign + \
               self.sh_entsize

e_hdr = Elf64_Ehdr(binary)
e_hdr.e_ident.OSABI = bytes([0x00])
e_hdr.e_machine = bytes([0x3e,0x00])

with open('lvl2', 'rb') as f:
    bin2 = f.read()
e_hdr2 = Elf64_Ehdr(bin2)
e_hdr.e_phoff = e_hdr2.e_phoff

fixed_header = e_hdr.get() + binary[64:]
print("[*] Fixed header.")

e_shentsize = int.from_bytes(e_hdr.e_shentsize, byteorder='little')
e_shoff = int.from_bytes(e_hdr.e_shoff, byteorder='little')
e_shnum = int.from_bytes(e_hdr.e_shnum, byteorder='little')
fixed_section = fixed_header[:e_shoff]
print(f"e_shoff : {hex(e_shoff)}")
print(f"e_shentsize: {e_shentsize}")
print(f"e_shnum: {e_shnum}")
for i in range(e_shoff, e_shoff+(e_shnum*e_shentsize), e_shentsize):
    s_hdr = Elf64_Shdr(fixed_header[i:i+e_shentsize])
    if ((i-e_shoff)/e_shentsize) == 14:
        #print(f"before {s_hdr.sh_type.hex()}")
        s_hdr.sh_type = fix
    else:
        if ((i-e_shoff)/e_shentsize) == 13:
            fix = s_hdr.sh_type
    print(f"[{((i-e_shoff)/e_shentsize)}]\t0x{i} {s_hdr.sh_type.hex()}")
    fixed_section += s_hdr.get()
    #print(s_hdr.get().hex())

print("[*] Fixed section.")

with open('lvl3_fixed', 'wb') as f:
    f.write(fixed_section)
