ZASM_FLAGS := --labels --z80 --casefold
local_path = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

TEST_SYSTEM = "sg1000"
#TEST_SYSTEM = "sc3000"

all: camel80.sc

camel80.sc: camel80.asm camel80h.asm camel80d.asm shared/*.asm
	zasm ${ZASM_FLAGS} camel80.asm camel80.sc

run: camel80.sc
	cd ${MAME_PATH} && ./mame64 ${TEST_SYSTEM} -cart ${local_path}camel80.sc

debug: camel80.sc
	cd ${MAME_PATH} && ./mame64 ${TEST_SYSTEM} -debug -cart ${local_path}camel80.sc

openshots:
	open ${MAME_PATH}/snap/${TEST_SYSTEM}

pad: camel80.sc
	python3 ./prepare.py -s 256 camel80.sc

burn: pad camel80.padded.bin
	minipro -p MX27C256@DIP28 -w camel80.padded.bin

clean:
	rm -rf camel80.sc
	rm -rf camel80.lst
	rm -rf camel80.padded.bin
