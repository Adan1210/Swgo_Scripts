#
# General Makefile for linking with ROOT
#
USER_SRCS = $(wildcard *.cc)
#
# Executable names come from the .cc sources in this directory.
# Replace the wildcard expression with .cc file list if you do
# not want to compile all .cc files in this directory
#
EXE = $(patsubst %.cc,%, $(wildcard *.cc))
#
#############################################################

## You should not need to change anything below this line ###

.PHONY: all depend clean


ROOT_CXXFLAGS    = $(shell $(ROOTSYS)/bin/root-config --cflags)
ROOT_LDFLAGS     = $(shell $(ROOTSYS)/bin/root-config --ldflags)
ROOT_LDFLAGS    += $(shell $(ROOTSYS)/bin/root-config --libs)

all: $(EXE)

%: %.cc
	$(CXX) $^ $(ROOT_CXXFLAGS)  $(ROOT_LDFLAGS) -lMinuit -o $@

#############################################################
# gcc can generate the dependency list

depend: Make-depend

Make-depend: $(USER_SRCS)
	$(CPP) $(ROOT_CXXFLAGS)  -MM $^ > $@

clean:
	- rm -f *.o  *.so *.ps core Make-depend $(EXE)

-include Make-depend
