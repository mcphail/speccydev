speccydev.tzx: speccydev.tap
	tapeconv speccydev.tap speccydev.tzx

speccydev.tap: sjasm.tap loader.tap boriel.zx0.block
	cat loader.tap sjasm.tap boriel.zx0.block > speccydev.tap

myprog.sna sjasm.tap myprog.sld: speccydev.asm dzx0_standard.asm boriel.zx0
	sjasmplus --sld=myprog.sld --fullpath speccydev.asm

loader.tap: loader.bas
	zmakebas -a 30 -n SpeccyDev -o loader.tap loader.bas

boriel.bin: boriel.zxb
	zxbc -S 40000 -o boriel.bin boriel.zxb

boriel.zx0: boriel.bin
	zx0 -f boriel.bin boriel.zx0

boriel.zx0.block: boriel.zx0
	ttttt boriel.zx0 data

clean:
	rm -f *.tap
	rm -f *.sna
	rm -f *.sld
	rm -f *.block
	rm -f *.tzx
	rm -f *.bin
	rm -f *.zx0
	rm -rf .tmp/

start_new_project:
	make clean
	rm -rf .git
	git init -b main
	git add .devcontainer/ .vscode/ .gitignore
	git commit -m "New project"
	rm -rf *

.PHONY: clean start_new_project
