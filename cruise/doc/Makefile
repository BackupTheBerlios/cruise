#
# Makefile for cruise specification
#
# $Id: Makefile,v 1.1 2001/08/03 20:17:14 klauko70 Exp $
#

PROJECTNAME = cruisespec


ps: $(PROJECTNAME).ps

preview: $(PROJECTNAME).dvi
	xdvi $(PROJECTNAME).dvi

all: ps preview 



$(PROJECTNAME).ps: $(PROJECTNAME).dvi
	dvips $(PROJECTNAME)


$(PROJECTNAME).dvi: *.tex 
	jpg2eps.sh
	latex $(PROJECTNAME)


# it would be better if jpg2eps is only called when necessary
# or if it converts only the pictures which have changed -> future work :-)

clean:
	rm -f *.aux *.bbl *.blg *.dep *.glo *.gls *.ilg *.log
	rm -f *.out *.toc *.lot *.lof *.mpx *~


