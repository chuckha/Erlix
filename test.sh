#!/bin/sh

echo "Testing cat"
echo

expected=`/bin/cat test.txt`
result=`bin/cat test.txt`

printf "cat should print the contents of a file...    "
if [ "$expected"="$result" ]
then
        echo "OK"
else
        echo "F"
        echo "expected: $expected"
        echo "     got: $result"
        exit 1
fi
