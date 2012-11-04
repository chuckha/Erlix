#!/bin/sh

assert_equal () {
        expected="$1"
        result="$2"
        if [ "$expected" == "$result" ] 
        then
                echo "OK"
        else
                echo "F"
                echo "expected: $expected"
                echo "     got: $result"
        fi
}

