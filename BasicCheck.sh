#!/bin/bash
dir_path="$1"
program="$2"
t=0
d=0
cd $dir_path
make 
makesecsses=$?

if [[ ( -f Makefile)&&($makesecsses -eq "0") ]]; then
	echo "Compilation PASS"
else 
	echo "Compilation FAIL"
exit 7

fi

valgrind --leak-check=full --error-exitcode=1 ./$program 

valgrind_output=$?
if [[ ( $valgrind_output -eq "0" ) ]];then
	echo "Memory leaks PASS"
else
 	echo "Memory leaks FAIL" 
	$t=1
fi
valgrind --tool=helgrind --error-exitcode=1 ./$program
helgrind_output=$?
if [[ ($helgrind_output -eq "0") ]];then
	echo "thread race PASS"
else 
	echo "thread race FAIL"
 	$d=1
fi
if [[ ($helgrind_output -eq 0)&&($valgrind_output -eq 1) ]];then
	exit 2
elif [[ ($helgrind_output -eq 1)&&($valgrind_output -eq 0) ]];then
	exit 1
elif [[ ($helgrind_output -eq 0)&&($valgrind_output -eq 0) ]];then
	exit 0
elif [[ ($helgrind_output -eq 1)&&($valgrind_output -eq 1) ]];then
	exit 3

fi
exit 0

## 4 2 1
