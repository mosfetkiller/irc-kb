# simple makefile for latex processing with glossaries
# written by jwacalex for Team2 - SEP WS2012/13 @ Uni Passau
# revision by doeme for #mosfetkiller @ irc.rizon.net 
# you can find the current version there: 
# https://raw.github.com/jwacalex/linux_wiki/master/Makefile

# filename without extention
NAMEBASE=mosfetkiller


TEMPORARY_FILES=$(NAMEBASE).acn $(NAMEBASE).acr $(NAMEBASE).alg $(NAMEBASE).aux $(NAMEBASE).bak $(NAMEBASE).bbl $(NAMEBASE).blg $(NAMEBASE).dvi $(NAMEBASE).fdb_latexmk $(NAMEBASE).glg  $(NAMEBASE).glo  $(NAMEBASE).gls $(NAMEBASE).idx $(NAMEBASE).ilg $(NAMEBASE).ind $(NAMEBASE).ist $(NAMEBASE).lof $(NAMEBASE).log $(NAMEBASE).lot $(NAMEBASE).maf $(NAMEBASE).mtc $(NAMEBASE).mtc0 $(NAMEBASE).nav $(NAMEBASE).nlo $(NAMEBASE).out $(NAMEBASE).pdfsync $(NAMEBASE).ps $(NAMEBASE).snm $(NAMEBASE).synctex.gz $(NAMEBASE).tdo $(NAMEBASE).thm $(NAMEBASE).toc $(NAMEBASE).vrb $(NAMEBASE).xdy

LATEX=latex
LATEXOPTS=-shell-escape -halt-on-error
CONVERT=convert
DENSITY=500

# creates the document, (merges with glossary,) cleans up temp. files
all: tex 

# creating the pdf from tex
tex: $(NAMEBASE).pdf

# createing the glossary
glossary: tex
	makeglossaries $(NAMEBASE)
	
%.pdf: %.tex %.toc %.aux
	$(LATEX) $(LATEXOPTS) -output-format pdf $<
%.dvi: %.tex 
	$(LATEX) $(LATEXOPTS) -output-format dvi $<
%.png: %.pdf
	$(CONVERT) -density $(DENSITY) $< $@


# cleanup temporary files
.PHONY:
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
