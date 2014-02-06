# Simple makefile for latex processing with glossaries
# and new(!) with bibtex makeing.
# Written by jwacalex for Team2 - SEP WS2012/13 @ Uni Passau
# Revision by Doeme for #mosfetkiller @ irc.rizon.net 
# You can find the current version there: 
# https://raw.github.com/jwacalex/linux_wiki/master/Makefile

# Filename with extension
TARGET=mosfetkiller.pdf
DEPENDENCIES:=$(wildcard parts/*.tex)



# --- { people who change something beyond this point should make a commit } ---

# --- [ internal setup ] ---

NAMEBASE=$(basename $(TARGET))
FEATUREDEPS:=$(wildcard *.bib)
TEMPORARY_FILES=$(addprefix $(NAMEBASE)., acn acr alg aux bak bbl blg dvi fls fdb_latexmk glg fglo gls idx ilg ind ist lof log lot maf mtc mtc0 nav nlo out pdfsync ps snm synctex.gz tdo thm toc vrb xdy)

.PHONY: clean cleanpdf cleanbak cleanall %.gls all tex
.SECONDARY: %.toc %.tex %.bib

# --- [ cmd-line options ] ---
# options to build latex
LATEXOPTS=-shell-escape -halt-on-error

# density for convert (pdf to png)
DENSITY=500

# --- [ commands ] ---
# latex-binary
LATEX=latex

# makeglossaries perl skript
MAKEGLOS=makeglossaries

# bibtex binary
BIBTEX=bibtex

# convert binary form imagemagick
CONVERT=convert

# --- [ main targets ] ---

# creates the document, (merges with glossary, and bibli) cleans up temporary files
all: tex

# creates the target
tex : $(TARGET)
$(TARGET):  $(FEATUREDEPS) $(DEPENDENCIES)
# funny reload in case of glossary or bibtexfile -file
ifneq (,$(wildcard $(NAMEBASE).glo))
	make $(NAMEBASE).gls
endif
ifneq (,$(wildcard $(NAMEBASE).bib))
	make $(NAMEBASE).bbl
endif


# creates a pdf-document from a tex-file
%.pdf: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format pdf $<

# creates a div-file from a given tex
%.dvi: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format dvi $<

# converts a given pdf to a png-file
%.png: %.pdf
	$(CONVERT) -density $(DENSITY) $< $@

# dummy-target
%.tex: 


# --- [ clean up targes ] ---

# clean up temporary files
clean:
	rm -f $(TEMPORARY_FILES)

# remove pdf
cleanpdf:
	rm -f $(NAMEBASE).pdf

# remove *.bak
cleanbak:
	find -iname "*.bak" -exec rm '{}' '+'

# remove all compiled outputs
cleanall: clean cleanbak cleanpdf

# --- [ support targets ] ---

# makeing toc
%.toc: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
# makeing auxilary-files
%.aux: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<

# makeing biblography
%.bbl: %.aux %.bib %.tex
	$(BIBTEX) $(NAMEBASE).aux 
	$(LATEX) $(LATEXOPTS) -output-format pdf $(NAMEBASE).tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $(NAMEBASE).tex

# makeing glossaries
%.gls:	%.aux %.glo %.tex 
	$(MAKEGLOS) $(NAMEBASE)
	$(LATEX) $(LATEXOPTS) -output-format pdf $(NAMEBASE).tex
