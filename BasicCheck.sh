#!bin/bash
dir_path="$1"
program="$2"
((t=0))
cd &dir_path
[[-f Makefile]]
having_make=$?
make
secssesfullmake=$?
if[having_make -gt 0]||[secssesfullmake -gt 0];then
echo "Compilation FAIL "
exit 7
fi
echo "Compilation PASS"

valgrind ./"$program" $@
valgrind_outpt=$?
if["$valgrind_output" -eq 0];then
echo "Memory leaks PASS"
[else
 echo "Memory FAIL" 
((t=1))]
fi
valgrind --tool=helgrind ./"$program"
helgrind_output=$?
if["$helgrind_output" -eq 0];then
echo "thread race PASS"
[else 
echo "thread race FAIL" ((t=2))]
fi
exit &t
