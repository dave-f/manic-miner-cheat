# Makefile for BBC Micro B Manic Miner Level Select
# 03 December 2018
#

BEEBEM      := ../b2/build/r.linux/src/b2/b2
BEEBEM_OPTS := -b -0
BEEBASM     := ../beebasm/beebasm
GAME_SSD    := miner.ssd
OUTPUT_SSD  := cheat.ssd
MAIN_ASM    := main.asm
RM          := rm

#
# Phony targets
.PHONY: all clean run

all: $(OUTPUT_SSD)

$(OUTPUT_SSD): $(MAIN_ASM) Makefile
	$(BEEBASM) -i $(MAIN_ASM) -di $(GAME_SSD) -do $(OUTPUT_SSD)

clean:
	$(RM) $(OUTPUT_SSD)

run:
	$(BEEBEM) $(BEEBEM_OPTS) $(OUTPUT_SSD)
