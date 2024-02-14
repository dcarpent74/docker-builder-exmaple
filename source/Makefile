# A generic build template for C programs

# executable name
DBIN = hello
SBIN = $(DBIN).static

# C compiler
CC = gcc
# linker
LD = gcc

# C flags
CPPFLAGS = -Wall
# dependency-generation flags
DEPFLAGS = -MMD -MP
# linker flags
LDFLAGS = 
# linker flags
SLDFLAGS = -static
# library flags
LDLIBS = 

# build directories
BIN = bin
OBJ = obj
SRC = src

# build directories
INST = inst-root

SOURCES := $(wildcard $(SRC)/*.c)

OBJECTS := \
	$(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(wildcard $(SRC)/*.c))

# include compiler-generated dependency rules
DEPENDS := $(OBJECTS:.o=.d)

# compile C source
COMPILE.c = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) -c -o $@
# link objects
LINK.o = $(LD) $(LDFLAGS) $(LDLIBS) $(OBJECTS) -o $@
# static link objects
SLINK.o = $(LD) $(SLDFLAGS) $(LDLIBS) $(OBJECTS) -o $@

.DEFAULT_GOAL = dynamic

.PHONY: dynamic
dynamic: $(BIN)/$(DBIN)

.PHONY: static
static: $(BIN)/$(SBIN)

$(BIN)/$(DBIN): $(SRC) $(OBJ) $(BIN) $(OBJECTS)
	$(LINK.o)

$(BIN)/$(SBIN): $(SRC) $(OBJ) $(BIN) $(OBJECTS)
	$(SLINK.o)

$(SRC):
	mkdir -p $(SRC)

$(OBJ):
	mkdir -p $(OBJ)

$(BIN):
	mkdir -p $(BIN)

$(INST):
	mkdir -p $(INST)

$(OBJ)/%.o:	$(SRC)/%.c
	$(COMPILE.c) $<

# force rebuild
.PHONY: remake
remake: clean $(BIN)/$(DBIN)

# force static rebuild
.PHONY: remake-static
remake-static: clean $(BIN)/$(SBIN)

.PHONY: install
install: $(BIN)/$(DBIN) $(INST)
	install -m 755 $(BIN)/$(DBIN) $(INST)/$(DBIN)
	./copylibs.sh $(INST)

.PHONY: install-static
install-static: $(BIN)/$(SBIN) $(INST)
	install -m 755 $(BIN)/$(SBIN) $(INST)/$(DBIN)

# remove previous build and objects
.PHONY: clean
clean:
	$(RM) $(OBJECTS)
	$(RM) $(DEPENDS)
	$(RM) $(BIN)/$(SBIN)
	$(RM) $(BIN)/$(DBIN)
	$(RM) -r $(INST)

# remove everything except source
.PHONY: reset
reset:
	$(RM) -r $(OBJ)
	$(RM) -r $(BIN)
	$(RM) -r $(INST)

-include $(DEPENDS)
