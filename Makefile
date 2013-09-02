# Simple makefile for latex processing with glossaries
# Written by jwacalex for Team2 - SEP WS2012/13 @ Uni Passau
# Revision by Doeme for #mosfetkiller @ irc.rizon.net 
# You can find the current version there: 
# https://raw.github.com/jwacalex/linux_wiki/master/Makefile

# Filename with extension
TARGET=mosfetkiller.pdf

NAMEBASE=$(basename $(TARGET))
DEPENDENCIES:=$(wildcard parts/*.tex)
FEATUREDEPS:=$(wildcard $(NAMEBASE).glo) $(wildcard *.bib)

TEMPORARY_FILES=$(addprefix $(NAMEBASE)., acn acr alg aux bak bbl blg dvi fdb_latexmk glg  glo  gls idx ilg ind ist lof log lot maf mtc mtc0 nav nlo out pdfsync ps snm synctex.gz tdo thm toc vrb xdy)

LATEX=latex
MAKEGLOS=makeglossaries
BIBTEX=bibtex
LATEXOPTS=-shell-escape -halt-on-error
CONVERT=convert
DENSITY=500

# Creates the document, (merges with glossary,) cleans up temporary files
all: tex
# Creating the pdf from tex
tex : $(TARGET)
$(TARGET):  $(FEATUREDEPS) $(DEPENDENCIES) 
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

# Remove all compiled outputs
cleanall: clean cleanbak cleanpdf

.SECONDARY:
%.toc: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.aux: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.bib: $(NAMEBASE).aux 
	$(BIBTEX) $(NAMEBASE).aux 
	$(LATEX) $(LATEXOPTS) -output-format pdf $(NAMEBASE).tex
	#Since we do not make the target, we have to at least touch it.
	touch $@ 
%.gls: $(NAMEBASE).aux 
	$(MAKEGLOS) $(NAMEBASE).aux 
	$(LATEX) $(LATEXOPTS) -output-format pdf $(NAMEBASE).tex
	#Since we do not make the target, we have to at least touch it.
	touch $@
