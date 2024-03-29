#!/bin/sh

BIN_DIR=`pwd`/bin
SYS_BIN_DIR=/bin

cd test
source test_functions.sh

# Setup the correct binaries
PROG="cat"
ERL_CAT=$BIN_DIR/$PROG
SYS_CAT=$SYS_BIN_DIR/$PROG

echo "Testing cat"
echo

expected=`$SYS_CAT test.txt`
result=`$ERL_CAT test.txt`

printf "cat should print the contents of a file."
printf "    "
assert_equal "$expected" "$result"

expected=`$SYS_CAT test.txt test2.txt`
result=`$ERL_CAT test.txt test2.txt`

printf "cat should print the contents of all the files."
printf "    "
assert_equal "$expected" "$result"

expected=`$SYS_CAT -n test.txt`
result=`$ERL_CAT -n test.txt`

printf "cat -n should print the line numbers of a file including blank lines."
printf "    "
assert_equal "$expected" "$result"

