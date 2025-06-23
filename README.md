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

## Install

This devcontainer should work in Windows, Linux and MacOS. It is recommended to install:
- git, then configure user name and email address
- docker, or alternative like podman
- (Windows only, optional) Windows Subsystem for Linux, version 2
- Microsoft's vscode
- the "Dev Containers" extension (from Microsoft) within vscode

Make sure docker (or your alternative) is running before trying to use the devcontainer.

## Usage

![A terminal window running the commands outlined below](res/speccydev.gif)

Open a terminal and navigate to the directory which will contain your Spectrum projects. Run `git clone https://github.com/mcphail/speccydev.git your_project_name` and enter that directory. Start vscode by running `code .` inside the directory.

If you have installed the Dev Containers extension correctly, a popup will offer to reload the project within a devcontainer. Go ahead and allow this. The first time you use this devcontainer, it may take a few minutes to download and start. It should open more quickly on subsequent use.

Open the bottom bar in vscode to expose the terminal or select "Terminal -> New Terminal" from the menu bar. Try running some Linux commands like `ls -lh` or `date`. Build the example project by running `make` from the terminal or the VSCode extension. Experiment with editing some of the source files and running `make` again. Experiment with some of the assemblers, compilers and other tools mentioned above. The `Makefile` contains example usage of tools like sjasmplus, zmakebas, Boriel's BASIC and the FUSE utilities.

When you are ready to start your own project, run `make start_new_project` to wipe out the example code and start afresh.

## Debugging

Debug in the built in simulator or in CSpect externally (example CSpect invocation on Windows would be `CSpect.exe -w2 -debug -remote`). The simulator is set up to expect a binary called `myprog.sna` and a map file called `myprog.sld` but this can be configured in the `.vscode/launch.json` file.

*Note: to use CSpect debugging from a Linux host you will have to edit the file `.vscode/launch.json` to change the `"hostname"` parameter to `"localhost"`*
