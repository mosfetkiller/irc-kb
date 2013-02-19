# simple makefile for latex processing with glossaries
# filename without extention
# written by jwacalex for Team2- SEP WS2012/13 @ Uni Passau
NAMEBASE=linux
TEMPORARY_FILES=$(NAMEBASE).gls $(NAMEBASE).aux $(NAMEBASE).glg $(NAMEBASE).glo $(NAMEBASE).ist $(NAMEBASE).log $(NAMEBASE).out $(NAMEBASE).toc $(NAMEBASE).bak $(NAMEBASE).xdy $(NAMEBASE).thm
LATEX=latex
LATEXOPTS=-shell-escape -halt-on-error
CONVERT=convert
DENSITY=500
# creates the document, (merges with glossary,) cleans up temp. files
all: tex 

# creating the pdf from tex
tex: $(NAMEBASE).pdf

	


%.pdf: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.dvi: %.tex 
	$(LATEX) $(LATEXOPTS) -output-format dvi $<
%.png: %.pdf
	$(CONVERT) -density $(DENSITY) $< $@

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

.SECONDARY:
%.toc: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.aux: %.tex
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
