#!/usr/bin/env bash

set -x
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"

# Don't use colours if FD 1 (STDOUT) is NOT opened on a terminal
if test -t 1; then
        RED_BEGIN="$(tput setaf 1)"
        GREEN_BEGIN="$(tput setaf 2)"
        NORMAL="$(tput sgr0)"
else
        RED_BEGIN=""
        GREEN_BEGIN=""
        NORMAL=""
fi

BASE_URL="https://www.btopenzone.com:8443"
LOGOUT_URL="$BASE_URL/accountLogoff/home?confirmed=true"

if [ "$1" == "--logout" ]; then
	curl -A "$USER_AGENT" "$LOGOUT_URL" || echo "${RED_BEGIN}Failed to log you out${NORMAL}"
else

	USERNAME=$1
	PASSWORD=$2
	CHECK_STATUS_URL="$BASE_URL/home"
	LOGIN_URL="$BASE_URL/ante"

	if curl -A "$USER_AGENT" "$CHECK_STATUS_URL" 2>/dev/null | grep -q "re now logged on to BT Wi-Fi"; then
		echo "${GREEN_BEGIN}you're logged in${NORMAL}"
	else
		echo "Trying to log you in..."
		if wget -qO - --header='Accept: text/html' --user-agent "$USER_AGENT" --post-data "inputUsername=${USERNAME}&username=wam/${USERNAME}&password=${PASSWORD}" $LOGIN_URL 2>/dev/null | grep -q "re now logged on to BT Wi-Fi"; then
			echo "${GREEN_BEGIN}you've been logged in${NORMAL}"
		else
			echo "${RED_BEGIN}Something went wrong${NORMAL}"
		fi
	fi
fi
