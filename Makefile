# Simple makefile for latex processing with glossaries
# Written by jwacalex for Team2 - SEP WS2012/13 @ Uni Passau
# Revision by Doeme for #mosfetkiller @ irc.rizon.net 
# You can find the current version there: 
# https://raw.github.com/jwacalex/linux_wiki/master/Makefile

# Filename with extension
TARGET=mosfetkiller.pdf

NAMEBASE=$(basename $(TARGET)) 
DEPENDENCIES:=$(wildcard parts/*.tex)

TEMPORARY_FILES=$(NAMEBASE).acn $(NAMEBASE).acr $(NAMEBASE).alg $(NAMEBASE).aux $(NAMEBASE).bak $(NAMEBASE).bbl $(NAMEBASE).blg $(NAMEBASE).dvi $(NAMEBASE).fdb_latexmk $(NAMEBASE).glg  $(NAMEBASE).glo  $(NAMEBASE).gls $(NAMEBASE).idx $(NAMEBASE).ilg $(NAMEBASE).ind $(NAMEBASE).ist $(NAMEBASE).lof $(NAMEBASE).log $(NAMEBASE).lot $(NAMEBASE).maf $(NAMEBASE).mtc $(NAMEBASE).mtc0 $(NAMEBASE).nav $(NAMEBASE).nlo $(NAMEBASE).out $(NAMEBASE).pdfsync $(NAMEBASE).ps $(NAMEBASE).snm $(NAMEBASE).synctex.gz $(NAMEBASE).tdo $(NAMEBASE).thm $(NAMEBASE).toc $(NAMEBASE).vrb $(NAMEBASE).xdy

LATEX=latex
LATEXOPTS=-shell-escape -halt-on-error
CONVERT=convert
DENSITY=500

# Creates the document, (merges with glossary,) cleans up temporary files
all: tex
# Creating the pdf from tex
tex : $(TARGET)
$(TARGET): $(DEPENDENCIES)
# Creating the glossary
glossary: tex
	makeglossaries $(NAMEBASE)
%.pdf: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.dvi: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format dvi $<
%.png: %.pdf
	$(CONVERT) -density $(DENSITY) $< $@
%.tex: 
# Clean up temporary files
.PHONY:
clean:
	rm -f $(TEMPORARY_FILES)

# Remove pdf
cleanpdf:
	rm -f $(NAMEBASE).pdf

# Remove *.bak
cleanbak:
	find -iname "*.bak" -exec rm '{}' '+'

.SECONDARY:
%.toc: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.aux: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
