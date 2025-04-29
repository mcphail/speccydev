# Development tools for the ZX Spectrum

The Dockerfile is the basis of the devcontainer and can be changed to add or remove tools. It will take a long time to build locally, so by default the devcontainer will pull a prebuilt version. Edit `.devcontainer/devcontainer.json` if you would rather build your own.

The devcontainer contains:
- pasmo (assembler)
- sjasmplus (assembler)
- z80asm (assembler)
- z80dasm (disassembler)
- zmakebas (creates BASIC programs)
- z88dk (C compiler and other utilities including assembler)
- utilities from the FUSE emulator:
    - audio2tape
    - createhdf
    - fmfconv
    - listbasic
    - profile2map
    - raw2hdf
    - rzxcheck
    - rzxdump
    - rzxtool
    - scl2trd
    - snap2tzx
    - snapconv
    - snapdump
    - tape2pulses
    - tape2wav
    - tapeconv
    - tzxlist
- zx0 (binary compressor)
- dzx0 (binary decompressor)
- ZX BASIC (aka Boriel BASIC)
    - zxbc (BASIC compiler)
    - zxbasm (assembler)
    - zxbpp (preprocessor)
- ttttt (converts binaries into .tap blocks)
- git (version control)
- make (build control)

Build the example project by running `make` from the terminal or the VSCode extension.

Debug in the built in simulator or in CSpect externally (example CSpect invocation on Windows would be `CSpect.exe -w2 -debug -remote`).
*Note: to use CSpect debugging from a Linux host you will have to edit the file `.vscode/launch.json` to change the `"hostname"` parameter to `"localhost"`*
