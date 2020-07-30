
SHELL = /bin/bash -O extglob
SC = swiftc
FLG = -v 

start:
	@echo "make [<filename>|all|run|clean]"

%: %.swift
	@$(SC) $(FLG) $<

all:
	@for i in *.swift; do echo && echo " == $$i: "; $(SC) $(FLG) $$i; done

run: all
	@for i in !(*.swift|Makefile*|datafile*|README*); do clear && echo && echo " == $$i: "; ./$$i; done

clean:
	@rm -f !(*.swift|Makefile*|datafile|README*)

.PHONY: all run clean
