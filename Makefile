#
# Curriculm Vitae of Jun Koda
# junkoda_cv_publication  : resume + publications + references
# junkoda_cv              : resume + refernces
# junkoda_publications    : publication list only
#
# This directory is for UK English

.SUFFIXES  :
.SECONDARY : 
.PHONY     : all clean mostlyclean check

LATEX   = latex
SPELL   = aspell --lang=en_GB -c -t
BIBFILE = junkoda

FILES  := junkoda_cv_minimum junkoda_cv junkoda_cv_publication
FILES  += junkoda_publications junkoda_references

PDFS   := $(foreach base, $(FILES), $(base).pdf) 
TEXS   := $(foreach base, $(FILES), $(base).tex) vitae.tex publications.tex references.tex

all : $(PDFS) junkoda_bib.pdf

#
# Exceptional Dependence
#
publications.tex: ../publications.tex
	cat $< | sed -e 's/``{/`{\\it /' -e "s/},''/}',/" > $@


# including common tex files 
junkoda_cv_publication.pdf: vitae.tex publications.tex references.tex style.tex
junkoda_cv.pdf:             vitae.tex                  references.tex style.tex
junkoda_publications.pdf:             publications.tex                style.tex
junkoda_references.pdf:                                references.tex style.tex
junkoda_cv_minimum.pdf:     vitae.tex                                 style.tex

# generating bbl files
junkoda_bib.pdf: junkoda_bib.tex junkoda_bib.bbl junkoda.bib


#
# General Make Rules
#
%.aux : %.tex $(BIBFILE).bib
	$(LATEX) $*

%.bbl : %.aux $(BIBFILE).bib junkoda.bst
	bibtex $*

%.aux : %.tex $(BIBFILE).bib
	$(LATEX) $*

%.pdf : %.tex
	pdflatex $*
	@grep -e 'may have changed' $*.log && rm $@; $(MAKE) $@ || echo "done."


#
# Delete all but primary source files
#
clean : 
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg \
           *.inx *.ps *.dvi *.pdf *.toc *.out *.lot

#
# Keep PDF files
#
mostlyclean :
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg \
           *.inx *.ps *.dvi *.toc *.out *.lot 


#
# Spell Check
#
check : $(TEXS)
	@echo "spell check"
	@for file in $^; do \
	    $(SPELL) $$file; echo $$file; \
	done
