/*
 * SPDX-License-Identifier: Apache-2.0
 *
 * Copyright 2025 asdftowel
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Formula constants */
#define G_RATIO 1.6180339887498948
#define SQRT_5  2.2360679774997897

/* Check if standard version is at least C99 */
#if __STDC_VERSION__ < 199901L
#error "This program requires support for C99 or higher."
#elif __STDC_VERSION__ < 202311L
#include <stdbool.h> /* To use human-readable booleans */
#endif

/* For GNU-compatible compilers: check if -ffast-math is enabled */
#ifdef __RECIPROCAL_MATH__
#warning "It appears that you have enabled fast math. This may cause \
the results to be inaccurate."
#endif

/* Compiler-dependent optimization hints */
#ifdef __GNUC__
#define PURE __attribute__ ((pure))
#define CONST __attribute__ ((const))
#elif __STDC_VERSION__ >= 202311L
#define PURE [[reproducible]]
#define CONST [[unsequenced]]
#else
#define PURE
#define CONST
#endif

PURE static inline bool verify_arg(char const * restrict const arg) {
    size_t const str_size = strlen(arg);
    bool result;
    /*
     * Splitting these conditions into separate branches
     * makes the function harder to read due to multiple
     * identical assignments.
     */
    if (
        /* The argument is either too short or too long */
        ((str_size == 0) | (str_size > 2)) ||
        /* The argument isn't a non-negative integer */
        (!isdigit(arg[0]) | ((str_size == 2) && !isdigit(arg[1]))) ||
        /*
         * The argument is greater than 93:
         * fibonacci(94) is greater than the maximum value
         * of unsigned long long (assuming standard-defined
         * ULLONG_MAX >= (uint64_t)-1)
         */
        ((arg[0] == '9') & (arg[1] > '3'))
    ) {
        result = false;
    } else {
        result = true;
    }
    return result;
}

CONST static inline unsigned long long fibonacci(int const n) {
    /*
     * Computes the nth Fibonacci number.
     * See rounding-based formula:
     * https://en.wikipedia.org/wiki/Fibonacci_sequence
     */
    return (unsigned long long)round(pow(G_RATIO, (double)n) / SQRT_5);
}

int main(int argc, char **argv) {
    int exit_code = EXIT_SUCCESS;
    if ((argc == 2) && verify_arg(argv[1])) {
        printf("fibonacci(%s) = %llu\n", argv[1], fibonacci(atoi(argv[1])));
    } else {
        puts(
            "The only argument must be a non-negative integer lesser than 93."
        );
        exit_code = EXIT_FAILURE;
    }
    return exit_code;
}
