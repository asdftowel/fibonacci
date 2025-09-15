#!/bin/sh

# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2025 asdftowel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TOTAL_TESTS=0
ERR_COUNT=0
# OEIS sequence A000045
NUMBERS='0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155'
CURRENT=40

cmp_result() {
    test "$(./fibonacci $1)" = "fibonacci($1) = $2"
    ERR_COUNT=$(($ERR_COUNT+$?))
    TOTAL_TESTS=$(($TOTAL_TESTS+1))
}

while [ $CURRENT -ge 0 ]
do
    cmp_result "$CURRENT" "`echo $NUMBERS | cut -d' ' -f$(($CURRENT+1))`"
    CURRENT=$(($CURRENT-1))
done

if [ $ERR_COUNT -ne 0 ]
then
    printf "$ERR_COUNT/$TOTAL_TESTS tests \033[1;31mfailed\033[0m.\n"
    exit 1
else
    printf "All tests \033[1;32mpassed\033[0m.\n"
    exit 0
fi