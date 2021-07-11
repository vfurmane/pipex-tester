#!/bin/bash

should_update()
{
	if [ -f .last-update ]
	then
		if source .last-update
		then
			last_hour=$(echo "$(date +%s) 3600" | awk '{printf "%d", $1 - $2}')
			if [ $LAST_UPDATE -le $last_hour ]
			then
				return 0
			else
				return 1
			fi
		else
			return 1
		fi
	else
		return 0
	fi
}

update_tester()
{
	if [ $(git status --porcelain 2> /dev/null | wc -l) -eq 0 ]
	then
		git fetch origin master > /dev/null 2>&1
	fi
	if ! git diff-index --quiet origin/master -- \
	&& [ $(git status --porcelain 2> /dev/null | wc -l) -eq 0 ]
	then
		update=-1
		while [ $update -ne 0 ] && [ $update -ne 1 ]
		do
			printf "Would you like to update the tester [Y/n] "
			read -N 1 -r update
			[[ "$update" != $'\n' ]] && echo
			case "$update" in
				[nN]) update=0 ;;
				[yY$'\n']) update=1 ;;
			esac
			if [ "$update" != "0" ] && [ "$update" != "1" ]
			then
				printf "${YELLOW}Unexpected answer. Please retry...${NC}\n"
				update=-1
			fi
		done
		if [ $update -eq 1 ]
		then
			git pull origin master
		fi
	fi
}
