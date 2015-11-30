#!/bin/bash

R1=0
#R1=`cat /tst`
T1=`echo 2`
R2=`echo 4`
T2=`echo 1`
echo "test -$R1- -$R2-"


function test() {
    if [ "$@" -eq "$@" ] 2>/dev/null
    then
        return 0
    else
        return 1
    fi
}

test 123
test 123a
test "a"
test " "
test ""

echo "text -$R1- -$T1-"

if test $R1 && test $T1
    then 
        echo "gagné"
fi