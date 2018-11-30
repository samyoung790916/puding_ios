LIBNAME=ssl

INC+= -I ./include

FLAGS= -fPIC -lpthread

TMP=objs

CSOURCES+= $(wildcard library/*.c)

COBJS = $(patsubst %.c, $(TMP)/%.o, $(CSOURCES))

all: objdirs $(LIBNAME)

objdirs:
	mkdir -p $(TMP)/
	mkdir -p $(TMP)/library/

# compile c code
$(filter %.o, $(COBJS)) : $(TMP)/%.o : %.c
	@echo gcc -g -c $< -o $@ 
	@gcc -c $< -o $@ -g $(INC) $(FLAGS)

# now link
$(LIBNAME) : $(OBJS) $(COBJS)
	@gcc -o $(LIBNAME) $(OBJS) $(COBJS) $(FLAGS)

clean:
	rm -rf $(LIBNAME) $(TMP)/*
