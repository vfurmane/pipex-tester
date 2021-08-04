#!/bin/bash

wait_for_timeout()
{
	sleep 2
	if kill -0 $1 > /dev/null 2>&1
	then
		kill $1
	fi
}

pipex_test()
{
	if [ $DISABLE_TIMEOUT -eq 0 ]
	then
		$MEMLEAKS "$@" &
		bg_process=$!
		wait_for_timeout $bg_process &
		wait $bg_process
	else
		"$@"
	fi
	status_code=$?
	return $status_code
}

pipex_verbose()
{
	if [ $VERBOSE -gt 0 ] && ([ "$result" != "OK" ] || [ "$result_color" != "$GREEN" ])
	then
		[ -f outs/test-$num.txt ] && echo "Your pipex:" && cat outs/test-$num.txt 
		[ -f outs/test-$num-original.txt ] && echo "Bash:" && cat outs/test-$num-original.txt 
		[ -f outs/test-$num-tty.txt ] && echo "Your tty output:" && cat outs/test-$num-tty.txt 
		[ -f outs/test-$num-exit.txt ] && echo "Your exit status:" && cat outs/test-$num-exit.txt 
	fi
}

pipex_summary()
{
	exec 1>&3
	printf "\n\n"
	printf "\t${BOLD}Summary${NC}\n\n" > /dev/stdout
	
	[ $TESTS_OK -gt 0 ] && printf "${GREEN}$TESTS_OK OK${NC}"
	[ $TESTS_OK -gt 0 ] && [ $TESTS_KO -gt 0 ] && printf " - "
	[ $TESTS_KO -gt 0 ] && printf "${RED}$TESTS_KO KO${NC}"
	([ $TESTS_OK -gt 0 ] || [ $TESTS_KO -gt 0 ]) && [ $TESTS_LK -gt 0 ] && printf " - "
	[ $TESTS_LK -gt 0 ] && printf "${RED}$TESTS_LK LK${NC}"
	([ $TESTS_OK -gt 0 ] || [ $TESTS_KO -gt 0 ] || [ $TESTS_LK -gt 0 ]) && [ $TESTS_TO -gt 0 ] && printf " - "
	[ $TESTS_TO -gt 0 ] && printf "${RED}$TESTS_TO TO${NC}"
	printf "\n\n"
	
	printf "${GREEN}OK${NC}: Test passed\n"
	printf "${YELLOW}OK${NC}: Not optimal or like bash (should not invalidate the project)\n"
	printf "${RED}KO${NC}: Test did not pass\n"
	printf "${RED}LK${NC}: Test detected leaks\n"
	printf "${RED}TO${NC}: Test timed out\n"
	
	if [ $TESTS_KO -eq 0 ] && [ $TESTS_LK -eq 0 ] && [ $TESTS_TO -eq 0 ]
	then
		exit 0
	else
		exit 1
	fi
}
