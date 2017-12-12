# BIOS (Low-level programming course (2014))

# Папки
source -- what was given to students for modification

chk -- binary extensions of the bios and utilities

at&t -- first version of bios in At&t asm 

chk -- binary extensions of the bios and utilities

src -- current version of bios in MASM asm

src5 -- non-working (read warning) bios version with paging

# Features (src version):
- Initializing the Interrupt Controller
- Initializing the Keyboard Controllers PS/2
- Initializing the video controller (by one of the extension modules)
- Initializing the timer (pit)
- Switch to Protected Mode
- Getting a pressed / pressed key from the keyboard by interrupting, which push the code to the ring buffer
- Pop the character from the ring buffer, converting to ASCII symbol. Shift and caps look modifiers are supported.
- Showing typing text on screen

# How to build 
- Windows: run build-bios.bat

- Linux: 
```
1. install wine

2. allow .exe files from folder which include script "build-bios-intel"

3. run build-bios-intel.
```
# How to run:
1. Rename file "bochsrc" to ".bochsrc"

2. install bochs

3. In the folder with project run in command line
```
bochs
```

# Warning:
Coming in the complete set ml.exe can not collect a normal bios (on idea the superfluous heading is added). Because of this, when making changes to the code, the BIOS can stop working. Sometimes one instruction "nop" can fix this behavior or conversely break down bios. Unfortunately, the problem was not exactly localized, because of this, a later version of the bios with paging stopped working (it locate in src5).
Note that the current version contains edits in working with the keyboard, which are not included in the version with paging.

# Paging task:
a) A security paging: pages with size 2M with PAE.

b) For those pages for which it is possible, the most efficient caching mode was used.

c) For the executable bios's code (range 0xF0000..0xFFFFF of physical addresses) use linear adresses from range 0xAF0000..0xAFFFFF.

d) For a range of linear adresses BDA (Bios Data Area), use physical addresses with 0x200000.

e) For a range of physical stack addresses, use linear addresses with 0x400000.
