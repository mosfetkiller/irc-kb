# simple makefile for latex processing with glossaries
# filename without extention
# written by jwacalex for Team2- SEP WS2012/13 @ Uni Passau
NAMEBASE=linux
TEMPORARY_FILES=$(NAMEBASE).gls $(NAMEBASE).aux $(NAMEBASE).glg $(NAMEBASE).glo $(NAMEBASE).ist $(NAMEBASE).log $(NAMEBASE).out $(NAMEBASE).toc $(NAMEBASE).bak $(NAMEBASE).xdy $(NAMEBASE).thm

# creates the document, (merges with glossary,) cleans up temp. files
all: clean tex 
	pdflatex $(NAMEBASE).tex
#	makeglossaries $(NAMEBASE)
	pdflatex $(NAMEBASE).tex
	rm -f $(TEMPORARY_FILES)

# creating the pdf from tex
tex:
	pdflatex $(NAMEBASE).tex

# createing the glossary
#glossary: tex
#	makeglossaries $(NAMEBASE)

# cleanup temporary files
clean:
	rm -f $(TEMPORARY_FILES)

#remove pdf
cleanpdf:
	rm -f $(NAMEBASE).pdf

#remove *.bak
cleanbak:
	find -iname "*.bak" -exec rm '{}' '+'
