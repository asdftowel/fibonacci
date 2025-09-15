.POSIX: ;

# Creates fastest executable by default
CC     = gcc
EXEEXT = # needed on platforms that have extensions for programs (e.g. Windows)
SRCDIR = . # Source directory (for out-of-tree builds)
CFLAGS = -O3 -march=native -flto=auto -fno-semantic-interposition -fno-trapping-math -fno-signed-zeros -fno-math-errno -ffinite-math-only
WFLAGS = -Wall -Wextra -Wshadow -Wconversion -Wpointer-arith -Werror -pedantic-errors
PGOGEN = -fprofile-generate # flags for generating instrumentation
PGOUSE = -fprofile-use # flags for using instrumentation
PROFEX = gcda # compiler-specific profile data file extension
PRCMND = # Additional commands to run for PGO
PFILES = # for compilers like clang which require explicit profile names
         # for example "=*.$(PROFEX)"

fibonacci: ${SRCDIR}/fibonacci.c
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o $@ $<

check: ${SRCDIR}/test_values.sh
	echo "TEST fibonacci${EXEEXT}"
	sh $<

clean:
	echo "RM fibonacci${EXEEXT}"
	rm fibonacci${EXEEXT}

pgo-instr: ${SRCDIR}/fibonacci.c
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o fibonacci $< $(PGOGEN)

pgo-build: ${SRCDIR}/fibonacci.c
	$(PRCMND)
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o fibonacci $< $(PGOUSE)$(PFILES)
	echo "RM prof"
	rm *.$(PROFEX)

pgo: pgo-instr check pgo-build

.SILENT: fibonacci check clean pgo-instr pgo-build pgo
