myprog.sna myprog.tap myprog.sld: main.asm loader.asm print.asm
	sjasmplus --sld=myprog.sld --fullpath main.asm

clean:
	rm -f *.tap
	rm -f *.sna
	rm -f *.sld
	rm -rf .tmp/

.PHONY: clean
