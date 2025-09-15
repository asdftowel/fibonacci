.POSIX: ;

# Creates fastest executable by default
CC     = gcc
# Source directory (for out-of-tree builds)
SRCDIR = .
CFLAGS = -O3 -march=native -flto=auto -fno-trapping-math -fno-signed-zeros -fno-math-errno -ffinite-math-only -lm
WFLAGS = -Wall -Wextra -Wshadow -Wconversion -Wpointer-arith -Werror -pedantic-errors
# flags for generating instrumentation
PGOGEN = -fprofile-generate
# flags for using instrumentation
PGOUSE = -fprofile-use
# compiler-specific profile data file extension
PROFEX = gcda
# needed on platforms that have extensions for programs (e.g. Windows)
EXEEXT =
# Additional commands to run for PGO
PRCMND =
# for compilers like clang which require explicit profile names, for example "=*.$(PROFEX)"
PFILES =

fibonacci: $(SRCDIR)/fibonacci.c
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o $@ $<

check: $(SRCDIR)/test_values.sh
	echo "TEST fibonacci$(EXEEXT)"
	sh $<

clean:
	echo "RM fibonacci$(EXEEXT)"
	rm fibonacci$(EXEEXT)

pgo-instr: $(SRCDIR)/fibonacci.c
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o fibonacci $< $(PGOGEN)

pgo-build: $(SRCDIR)/fibonacci.c
	$(PRCMND)
	echo "CCLD $<"
	$(CC) $(CFLAGS) $(WFLAGS) -o fibonacci $< $(PGOUSE)$(PFILES)
	echo "RM prof"
	rm *.$(PROFEX)

pgo: pgo-instr check pgo-build

.SILENT: fibonacci check clean pgo-instr pgo-build pgo;
