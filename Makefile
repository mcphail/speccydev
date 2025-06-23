myprog.sna myprog.tap myprog.sld: main.asm loader.asm print.asm
	sjasmplus --sld=myprog.sld --fullpath main.asm

clean:
	rm -f *.tap
	rm -f *.sna
	rm -f *.sld
	rm -rf .tmp/

start_new_project:
	make clean
	rm -rf .git
	git init -b main
	git add .devcontainer/ .vscode/ .gitignore
	git commit -m "New project"
	rm -rf *

.PHONY: clean start_new_project
