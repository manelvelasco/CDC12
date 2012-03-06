TOP := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
NAME=CDC12
INPUT = ${NAME}.tex
OUTPUT = $(NAME).dvi

$(OUTPUT) :CDC12.tex ejemplo.tex
	#git commit -am "AutoCommit"
	#sh vc.sh
	latex --src-specials CDC12.tex
	latex --src-specials CDC12.tex
	#evince $(TOP)$(OUTPUT)
clean:
	rm *.dvi
