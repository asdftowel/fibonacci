# O(1) Fibonacci function
[![Shell-based tests](https://github.com/asdftowel/fibonacci/actions/workflows/c.yml/badge.svg?branch=master&event=push)](https://github.com/asdftowel/fibonacci/actions/workflows/c.yml)

This program calculates the nth Fibonacci number using the rounding formula.
For example:
```shell
$ fibonacci 0
fibonacci(0) = 0
$ fibonacci 12
fibonacci(12) = 144
```
## Building, testing, etc.
There are four `make` rules:
 1. `make` - simply creates an executable
 2. `make check` - runs tests (first 40 numbers)
 3. `make clean` - removes executables, if any exist
 4. `make pgo` - builds optimized executable using
    tests for generating profiling data

See the Makefile for additional info on variables.
