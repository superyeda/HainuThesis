LATEXMK := latexmk
MAIN := main

.PHONY: all master doctor anonymous clean distclean

all: master

master:
	$(LATEXMK) -xelatex $(MAIN).tex

doctor:
	$(LATEXMK) -xelatex -jobname=$(MAIN)-doctor -usepretex="\PassOptionsToClass{degree=doctor}{hainanuthesis}" $(MAIN).tex

anonymous:
	$(LATEXMK) -xelatex -jobname=$(MAIN)-anonymous -usepretex="\PassOptionsToClass{anonymous=true}{hainanuthesis}" $(MAIN).tex

clean:
	$(LATEXMK) -c
	rm -f $(MAIN)-doctor.* $(MAIN)-anonymous.*

distclean:
	$(LATEXMK) -C
	rm -f $(MAIN).pdf $(MAIN)-doctor.pdf $(MAIN)-anonymous.pdf
