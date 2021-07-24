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
	git fetch origin master > /dev/null 2>&1
	if [ "$(git log --format='%H' -n 1 origin/master)" != "$(git log --format='%H' -n 1 master)" ]
	then
		update=-1
		while [ $update -ne 0 ] && [ $update -ne 1 ]
		do
			printf "Would you like to update the tester [Y/n] "
			nchars_opt="-N"
			if [[ "$OSTYPE" == "darwin"* ]]
			then
				nchars_opt="-n"
			fi
			read $nchars_opt 1 -r update
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
			git pull --no-edit origin master
		fi
	fi
}
