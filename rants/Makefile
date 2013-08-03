#Target specification is now mandatory. To make php.pdf, for example, you have to explicitly call "make php.pdf"
#This could be changed, but due to the philosohpy of this directory, it doesn't seem reasonable.

#Syntax is as follows: make <target> [Actions[, ...]]

TARGET=$(firstword $(MAKECMDGOALS))
.SILENT:
%:
	make -f ../Makefile $(filter-out $(TARGET),$(MAKECMDGOALS)) TARGET=$(TARGET)
