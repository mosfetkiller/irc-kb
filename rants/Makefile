TARGET=$(firstword $(MAKECMDGOALS))
.SILENT:
%:
	make -f ../Makefile $(filter-out $(TARGET),$(MAKECMDGOALS)) TARGET=$(TARGET)
