# oracle challenge
## level 0
### start (3 files)
- we start with three files
```bash
$ ls -l 
-rw-r--r-- 1 kali kali 8741312 Dec  1  2018 levels.db
-rwxr-xr-x 1 kali kali   10680 Nov 30  2018 oracle
-rw-r--r-- 1 kali kali    8633 Apr 19  2018 payload
$ file levels.db oracle payload
levels.db: ASCII text, with very long lines
oracle:    ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=083d1ffa7acfcf775c1e5f95dd870c8106aaf1f0, stripped
payload:   ASCII text
```

- we can try to run the elf executable, but it asks for shared library
```bash
$ ./oracle
./oracle: error while loading shared libraries: libcrypto.so.1.0.0: cannot open shared object file: No such file or directory
```

- we need to find libcrypto.so.1.0.0 library and to do that let's analyze the `payload` file

```bash
$ file payload
payload: ASCII text
$ head -n 2 payload
H4sIABzY61gAA+xaD3RTVZq/Sf+lFJIof1r+2aenKKh0klJKi4MmJaUvWrTSFlgR0jRN20iadpKX
UljXgROKjbUOKuOfWWfFnTlzZs/ZXTln9nTRcTHYERhnZ5c/R2RGV1lFTAFH/DNYoZD9vvvubd57
$ cat payload | base64 -d | file -
/dev/stdin: gzip compressed data, last modified: Mon Apr 10 19:08:12 2017, from Unix
$ cat payload | base64 -d | tar -xvz
ctf
67b8601
```

### ctf and 67b8601
- two files found inside the payload, let's see what's inside

```bash
$ file ctf 67b8601
ctf:     ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=29aeb60bcee44b50d1db3a56911bd1de93cd2030, stripped
67b8601: PC bitmap, Windows 3.x format, 512 x 512 x 24, image size 786434, resolution 7872 x 7872 px/m, 1165950976 important colors, cbSize 786488, bits offset 54
```

- the first file `ctf` is an executable, once launched it requires a shared library `lib5ae9b7f.so`

```bash
$ ./ctf
./ctf: error while loading shared libraries: lib5ae9b7f.so: cannot open shared object file: No such file or directory
$ ldd ctf
	linux-vdso.so.1 (0x00007fff8cd29000)
	lib5ae9b7f.so => not found
	libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f8878801000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f88787e7000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8878622000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f88784dd000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f8878a26000)
```

- let's see the bitmap file

```bash
$ xxd 67b8601 | head
00000000: 424d 3800 0c00 0000 0000 3600 0000 2800  BM8.......6...(.
00000010: 0000 0002 0000 0002 0000 0100 1800 0000  ................
00000020: 0000 0200 0c00 c01e 0000 c01e 0000 0000  ................
00000030: 0000 0000 7f45 4c46 0201 0100 0000 0000  .....ELF........
00000040: 0000 0000 0300 3e00 0100 0000 7009 0000  ......>.....p...
00000050: 0000 0000 4000 0000 0000 0000 7821 0000  ....@.......x!..
00000060: 0000 0000 0000 0000 4000 3800 0700 4000  ........@.8...@.
00000070: 1b00 1a00 0100 0000 0500 0000 0000 0000  ................
00000080: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000090: 0000 0000 f40e 0000 0000 0000 f40e 0000  ................
$ cat 67b8601 | cut -b 53- | file -
/dev/stdin: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, stripped 
$ cat 67b8601 | cut -b 53- > elf_header
```

### lib5ae96b7f.so

- now that we have extracted the elf file, use `readelf` to read the header and modify the library

```bash
$ readelf -h elf_header
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x970
  Start of program headers:          64 (bytes into file)
  Start of section headers:          8568 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         7
  Size of section headers:           64 (bytes)
  Number of section headers:         27
  Section header string table index: 26
readelf: Warning: Section 0 has an out of range sh_link value of 196608
readelf: Warning: Section 1 has an out of range sh_link value of 196608
readelf: Warning: Section 13 has an out of range sh_link value of 262144
readelf: Error: no .dynamic section in the dynamic segment
$ python3 -c 'print(8568+(64*27))'
10296
$ dd if=67b8601 of=lib5ae9b7f.so count=10296 bs=1 skip=52
10296+0 records in
10296+0 records out
10296 bytes (10 kB, 10 KiB) copied, 0.0291308 s, 353 kB/s
$ readelf -hs lib5ae9b7f.so
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x970
  Start of program headers:          64 (bytes into file)
  Start of section headers:          8568 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         7
  Size of section headers:           64 (bytes)
  Number of section headers:         27
  Section header string table index: 26

Symbol table '.dynsym' contains 22 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 00000000000008c0     0 SECTION LOCAL  DEFAULT    9 .init
     2: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
     3: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _Jv_RegisterClasses
     4: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND [...]@GLIBCXX_3.4.21 (2)
     5: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND [...]@GLIBC_2.2.5 (3)
     6: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterT[...]
     7: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMC[...]
     8: 0000000000000000     0 FUNC    WEAK   DEFAULT  UND [...]@GLIBC_2.2.5 (3)
     9: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __[...]@GLIBC_2.4 (4)
    10: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND [...]@GLIBCXX_3.4 (5)
    11: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND memcpy@GLIBC_2.14 (6)
    12: 0000000000000bc0   149 FUNC    GLOBAL DEFAULT   12 _Z11rc4_encryptP[...]
    13: 0000000000000cb0   112 FUNC    GLOBAL DEFAULT   12 _Z8rc4_initP11rc[...]
    14: 0000000000202060     0 NOTYPE  GLOBAL DEFAULT   24 _end
    15: 0000000000202058     0 NOTYPE  GLOBAL DEFAULT   23 _edata
    16: 0000000000000b40   119 FUNC    GLOBAL DEFAULT   12 _Z11rc4_encryptP[...]
    17: 0000000000000c60     5 FUNC    GLOBAL DEFAULT   12 _Z11rc4_decryptP[...]
    18: 0000000000202058     0 NOTYPE  GLOBAL DEFAULT   24 __bss_start
    19: 00000000000008c0     0 FUNC    GLOBAL DEFAULT    9 _init
    20: 0000000000000c70    59 FUNC    GLOBAL DEFAULT   12 _Z11rc4_decryptP[...]
    21: 0000000000000d20     0 FUNC    GLOBAL DEFAULT   13 _fini
```

- now could be useful to understand what's inside the library, so let's use `nm` to view symbols.
- remember to use `-D` parameter to resolve symbols dynamically, because the file is stripped as we can see

```bash
$ file lib5ae96b7f.so
lib5ae9b7f.so: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, BuildID[sha1]=5279389c64af3477ccfdf6d3293e404fd9933817, stripped
$ nm -D lib5ae96b7f.so
0000000000202058 B __bss_start
                 w __cxa_finalize@GLIBC_2.2.5
0000000000202058 D _edata
0000000000202060 B _end
0000000000000d20 T _fini
                 w __gmon_start__
00000000000008c0 T _init
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
                 w _Jv_RegisterClasses
                 U malloc@GLIBC_2.2.5
                 U memcpy@GLIBC_2.14
                 U __stack_chk_fail@GLIBC_2.4
0000000000000c60 T _Z11rc4_decryptP11rc4_state_tPhi
0000000000000c70 T _Z11rc4_decryptP11rc4_state_tRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
0000000000000b40 T _Z11rc4_encryptP11rc4_state_tPhi
0000000000000bc0 T _Z11rc4_encryptP11rc4_state_tRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
0000000000000cb0 T _Z8rc4_initP11rc4_state_tPhi
                 U _ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm@GLIBCXX_3.4.21
                 U _ZSt19__throw_logic_errorPKc@GLIBCXX_3.4
```

- we know that c++ allows functions to be overloaded and to eliminate duplicate names compilers emit mangled function names, so we need to pass `--demagle` parameter

```bash
$ nm -D --demangle lib5ae96b7f.so
0000000000202058 B __bss_start
                 w __cxa_finalize@GLIBC_2.2.5
0000000000202058 D _edata
0000000000202060 B _end
0000000000000d20 T _fini
                 w __gmon_start__
00000000000008c0 T _init
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
                 w _Jv_RegisterClasses
                 U malloc@GLIBC_2.2.5
                 U memcpy@GLIBC_2.14
                 U __stack_chk_fail@GLIBC_2.4
0000000000000c60 T rc4_decrypt(rc4_state_t*, unsigned char*, int)
0000000000000c70 T rc4_decrypt(rc4_state_t*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)
0000000000000b40 T rc4_encrypt(rc4_state_t*, unsigned char*, int)
0000000000000bc0 T rc4_encrypt(rc4_state_t*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)
0000000000000cb0 T rc4_init(rc4_state_t*, unsigned char*, int)
                 U std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_create(unsigned long&, unsigned long)@GLIBCXX_3.4.21
                 U std::__throw_logic_error(char const*)@GLIBCXX_3.4
```

- there's also another c++ utility to demangle function names `c++filt`

```bash
$ c++filt _Z11rc4_decryptP11rc4_state_tPhi
rc4_decrypt(rc4_state_t*, unsigned char*, int)
```

### ctf

- now we can use this shared library to run ctf

```bash
$ export LD_LIBRARY_PATH=`pwd`
$ ./ctf
$ echo $!
1
```

- use `strings` to search for interesting strings

```bash
$ strings ctf
...
DEBUG: argv[1] = %s
checking '%s'
show_me_the_flag
>CMb
-v@P^:
flag = %s
guess again!
It's kinda like Louisiana. Or Dagobah. Dagobah - Where Yoda lives!
...
```

- we can see that is asking for 1 argument, and it could be `show_me_the_flag`, let's try

```bash
$ ./ctf show_me_the_flag
checking 'show_me_the_flag'
ok
$ echo $!
1
```

- to make forward progress, let's investigate the reason that `ctf` exists with an error code by looking at `ctf`'s behavior just before if exit
- there are many ways to do this, one way is to use `ltrace` and `strace` utilities

```bash
$ strace ./ctf show_me_the_flag
execve("./ctf", ["./ctf", "show_me_the_flag"], 0x7ffc06d91198 /* 37 vars */) = 0
brk(NULL)                               = 0x1370000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/tls/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/tls/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/tls", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/x86_64/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/x86_64/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/x86_64/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/kali/wksp/ctfs/pba/code/chapter5/x86_64", 0x7ffee46a1a30) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\t\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=10296, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3ba290f000
mmap(NULL, 2105440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3ba270c000
mprotect(0x7f3ba270d000, 2097152, PROT_NONE) = 0
mmap(0x7f3ba290d000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f3ba290d000
close(3)                                = 0
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=92245, ...}) = 0
mmap(NULL, 92245, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f3ba26f5000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\321\t\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=2128936, ...}) = 0
mmap(NULL, 2144384, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3ba24e9000
mprotect(0x7f3ba2582000, 1449984, PROT_NONE) = 0
mmap(0x7f3ba2582000, 1003520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x99000) = 0x7f3ba2582000
mmap(0x7f3ba2677000, 442368, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18e000) = 0x7f3ba2677000
mmap(0x7f3ba26e4000, 57344, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1fa000) = 0x7f3ba26e4000
mmap(0x7f3ba26f2000, 10368, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3ba26f2000
close(3)                                = 0
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0203\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=100736, ...}) = 0
mmap(NULL, 103496, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3ba24cf000
mmap(0x7f3ba24d2000, 73728, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f3ba24d2000
mmap(0x7f3ba24e4000, 12288, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0x7f3ba24e4000
mmap(0x7f3ba24e7000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f3ba24e7000
close(3)                                = 0
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\200\177\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1839168, ...}) = 0
mmap(NULL, 1852480, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3ba230a000
mprotect(0x7f3ba2330000, 1658880, PROT_NONE) = 0
mmap(0x7f3ba2330000, 1347584, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x26000) = 0x7f3ba2330000
mmap(0x7f3ba2479000, 307200, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x16f000) = 0x7f3ba2479000
mmap(0x7f3ba24c5000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1ba000) = 0x7f3ba24c5000
mmap(0x7f3ba24cb000, 13376, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f3ba24cb000
close(3)                                = 0
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/libm.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\362\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=1325440, ...}) = 0
mmap(NULL, 1327376, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f3ba21c5000
mmap(0x7f3ba21d4000, 634880, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xf000) = 0x7f3ba21d4000
mmap(0x7f3ba226f000, 626688, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xaa000) = 0x7f3ba226f000
mmap(0x7f3ba2308000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x142000) = 0x7f3ba2308000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3ba21c3000
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f3ba21c0000
arch_prctl(ARCH_SET_FS, 0x7f3ba21c0740) = 0
mprotect(0x7f3ba24c5000, 12288, PROT_READ) = 0
mprotect(0x7f3ba2308000, 4096, PROT_READ) = 0
mprotect(0x7f3ba24e7000, 4096, PROT_READ) = 0
mprotect(0x7f3ba26e4000, 45056, PROT_READ) = 0
mprotect(0x7f3ba290d000, 4096, PROT_READ) = 0
mprotect(0x601000, 4096, PROT_READ)     = 0
mprotect(0x7f3ba293b000, 4096, PROT_READ) = 0
munmap(0x7f3ba26f5000, 92245)           = 0
brk(NULL)                               = 0x1370000
brk(0x1391000)                          = 0x1391000
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x1), ...}) = 0
write(1, "checking 'show_me_the_flag'\n", 28checking 'show_me_the_flag'
) = 28
write(1, "ok\n", 3ok
)                     = 3
exit_group(1)                           = ?
+++ exited with 1 +++
```

### syscalls

1. the first system call is `execve` called by the shell to launch the binary
2. as we can see the binary then searches in the current path for the shared library

```bash
openat(AT_FDCWD, "/home/kali/wksp/ctfs/pba/code/chapter5/lib5ae9b7f.so", O_RDONLY|O_CLOEXEC) 
```

3. then this library is read and mapped to memory 

```bash
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\t\0\0\0\0\0\0"..., 832)
```

- the first function called by `ctf` itself is

```bash
write(1, "checking 'show\_me\_the\_flag'\n", ...)
```

- we see another write call to print `ok` and finally `exit\_group(1)`
- looking at system calls didn't help much, let's try with library calls

### library calls

- now we can use `ltrace` to view all library calls during runtime

```bash
$ ltrace -C -i ./ctf show_me_the_flag
[0x400fe9] __libc_start_main(0x400bc0, 2, 0x7ffd13c070a8, 0x4010c0 <unfinished ...>
[0x400c44] __printf_chk(1, 0x401158, 0x7ffd13c075de, 224checking 'show_me_the_flag'
)                                                                     = 28
[0x400c51] strcmp("show_me_the_flag", "show_me_the_flag")                                                                     = 0
[0x400cf0] puts("ok"ok
)                                                                                                         = 3
[0x400d07] rc4_init(rc4_state_t*, unsigned char*, int)(0x7ffd13c06e60, 0x4011c0, 66, 0x7fea83c59963)                          = 0
[0x400d14] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::assign(char const*)(0x7ffd13c06da0, 0x40117b, 58, 3) = 0x7ffd13c06da0
[0x400d29] rc4_decrypt(rc4_state_t*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)(0x7ffd13c06e00, 0x7ffd13c06e60, 0x7ffd13c06da0, 0x7e889f91) = 0x7ffd13c06e00
[0x400d36] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_assign(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)(0x7ffd13c06da0, 0x7ffd13c06e00, 0x7ffd13c06e10, 0) = 0x7ffd13c06db0
[0x400d53] getenv("GUESSME")                                                                                                  = nil
[0xffffffffffffffff] +++ exited (status 1) +++
```

- we can see a call to `getenv`, which is a standard library function used to look up environment variables
- let's try to use random data inside `GUESSME` env variable

```bash
$ GUESSME='foobar' ./ctf show_me_the_flag
checking 'show_me_the_flag'
ok
guess again!
```

- use again `ltrace` with environment variable

```bash
$ GUESSME='foobar' ltrace -C -i ./ctf show_me_the_flag
[0x400fe9] __libc_start_main(0x400bc0, 2, 0x7ffe2b8d1b18, 0x4010c0 <unfinished ...>
[0x400c44] __printf_chk(1, 0x401158, 0x7ffe2b8d25cf, 224checking 'show_me_the_flag'
)                                                                     = 28
[0x400c51] strcmp("show_me_the_flag", "show_me_the_flag")                                                                     = 0
[0x400cf0] puts("ok"ok
)                                                                                                         = 3
[0x400d07] rc4_init(rc4_state_t*, unsigned char*, int)(0x7ffe2b8d18d0, 0x4011c0, 66, 0x7fe2eec3c963)                          = 0
[0x400d14] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::assign(char const*)(0x7ffe2b8d1810, 0x40117b, 58, 3) = 0x7ffe2b8d1810
[0x400d29] rc4_decrypt(rc4_state_t*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)(0x7ffe2b8d1870, 0x7ffe2b8d18d0, 0x7ffe2b8d1810, 0x7e889f91) = 0x7ffe2b8d1870
[0x400d36] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_assign(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)(0x7ffe2b8d1810, 0x7ffe2b8d1870, 0x7ffe2b8d1880, 0) = 0x7ffe2b8d1820
[0x400d53] getenv("GUESSME")                                                                                                  = "foobar"
[0x400d6e] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::assign(char const*)(0x7ffe2b8d1830, 0x401183, 5, 224) = 0x7ffe2b8d1830
[0x400d88] rc4_decrypt(rc4_state_t*, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >&)(0x7ffe2b8d1890, 0x7ffe2b8d18d0, 0x7ffe2b8d1830, 0x2219300) = 0x7ffe2b8d1890
[0x400d9a] std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_assign(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&)(0x7ffe2b8d1830, 0x7ffe2b8d1890, 0x2219330, 0) = 0x22192e0
[0x400db4] operator delete(void*)(0x2219330, 0x2219330, 21, 0)                                                                = 0
[0x400dd7] puts("guess again!"guess again!
)                                                                                               = 13
[0x400c8d] operator delete(void*)(0x22192e0, 0x2218eb0, 0, 0x7fe2eec3c963)                                                    = 0
[0xffffffffffffffff] +++ exited (status 1) +++
```

- after the call to `getenv`, `ctf` goes on to assign and decrypt another c++ string. unfortunately it doesn't show which string

### instruction-level behavior

- now we can use `objdump` to look inside binary data section and try to find the string


```bash
$ readelf -x .rodata ctf

Hex dump of section '.rodata':
  0x00401140 01000200 44454255 473a2061 7267765b ....DEBUG: argv[
  0x00401150 315d203d 20257300 63686563 6b696e67 1] = %s.checking
  0x00401160 20272573 270a0073 686f775f 6d655f74  '%s'..show_me_t
  0x00401170 68655f66 6c616700 6f6b004f 89df919f he_flag.ok.O....
  0x00401180 887e009a 5b38babe 27ac0e3e 434d6285 .~..[8..'..>CMb.
  0x00401190 55868954 3848a34d 00192d76 40505e3a U..T8H.M..-v@P^:
  0x004011a0 00726200 666c6167 203d2025 730a0067 .rb.flag = %s..g
  0x004011b0 75657373 20616761 696e2100 00000000 uess again!.....
  0x004011c0 49742773 206b696e 6461206c 696b6520 It's kinda like
  0x004011d0 4c6f7569 7369616e 612e204f 72204461 Louisiana. Or Da
  0x004011e0 676f6261 682e2044 61676f62 6168202d gobah. Dagobah -
  0x004011f0 20576865 72652059 6f646120 6c697665  Where Yoda live
  0x00401200 73210000 00000000                   s!......
```

- or using `objdump`

```bash
$ objdump -s --section .rodata ctf
ctf:     file format elf64-x86-64

Contents of section .rodata:
 401140 01000200 44454255 473a2061 7267765b  ....DEBUG: argv[
 401150 315d203d 20257300 63686563 6b696e67  1] = %s.checking
 401160 20272573 270a0073 686f775f 6d655f74   '%s'..show_me_t
 401170 68655f66 6c616700 6f6b004f 89df919f  he_flag.ok.O....
 401180 887e009a 5b38babe 27ac0e3e 434d6285  .~..[8..'..>CMb.
 401190 55868954 3848a34d 00192d76 40505e3a  U..T8H.M..-v@P^:
 4011a0 00726200 666c6167 203d2025 730a0067  .rb.flag = %s..g
 4011b0 75657373 20616761 696e2100 00000000  uess again!.....
 4011c0 49742773 206b696e 6461206c 696b6520  It's kinda like
 4011d0 4c6f7569 7369616e 612e204f 72204461  Louisiana. Or Da
 4011e0 676f6261 682e2044 61676f62 6168202d  gobah. Dagobah -
 4011f0 20576865 72652059 6f646120 6c697665   Where Yoda live
 401200 73210000 00000000                    s!......
```

- as we can see the `guess again` string is at `0x4011af`
- use `objdump` to decompile the binary and find which instruction loads the string

```bash
$ objdump -d ./ctf
...
  400dc0:       0f b6 14 03             movzx  edx,BYTE PTR [rbx+rax*1]
  400dc4:       84 d2                   test   dl,dl
  400dc6:       74 05                   je     400dcd <__gmon_start__@plt+0x21d>
  400dc8:       3a 14 01                cmp    dl,BYTE PTR [rcx+rax*1]
  400dcb:       74 13                   je     400de0 <__gmon_start__@plt+0x230>
  400dcd:       bf af 11 40 00          mov    edi,0x4011af
  400dd2:       e8 d9 fc ff ff          call   400ab0 <puts@plt>
  400dd7:       e9 84 fe ff ff          jmp    400c60 <__gmon_start__@plt+0xb0>
  400ddc:       0f 1f 40 00             nop    DWORD PTR [rax+0x0]
  400de0:       48 83 c0 01             add    rax,0x1
  400de4:       48 83 f8 15             cmp    rax,0x15
  400de8:       75 d6                   jne    400dc0 <__gmon_start__@plt+0x210>
...
```

- as we can see the `guess again` string is loaded by the instruction at `0x400dcd`
- let's work our way backward from here

### gdb

```bash
$ gdb -q ctf
Reading symbols from ctf...
(No debugging symbols found in ctf)
(gdb) set disassembly-flavor intel
(gdb) b *0x400dc8
Breakpoint 1 at 0x400dc8
(gdb) set env GUESSME=foobar
(gdb) run show_me_the_flag
Starting program: /home/kali/wksp/ctfs/pba/code/chapter5/ctf show_me_the_flag
checking 'show_me_the_flag'
ok

Breakpoint 1, 0x0000000000400dc8 in ?? ()
(gdb) display/i $pc
1: x/i $pc
=> 0x400dc8:	cmp    dl,BYTE PTR [rcx+rax*1]
(gdb) i r rcx
rcx            0x6152e0            6378208
(gdb) i r rax
rax            0x0                 0
(gdb) x/s 0x6152e0
0x6152e0:	"Crackers Don't Matter"
```

### solution

- run using environment and argument

```bash
$ GUESSME="Crackers Don't Matter" ./ctf show_me_the_flag
checking 'show_me_the_flag'
ok
flag = 84b34c124b2ba5ca224af8e33b077e9e
```

