#!/bin/bash
# This script will setup your basic authorization information for our REST API. This information is highly sensitive. Use it with care!

if ! which jq > /dev/null; then
	snap install jq
fi

if ! which urlencode > /dev/null; then
	sudo apt install gridsite-clients
fi

company=
echo -n "Enter your company name: "
read company
if [ -z "${company}" ]; then
	echo "No company name entered."
	exit 1
fi

echo -n "Enter your username (default: $USER): "
read username
if [ -z "${username}" ]; then
	username="${USER}"
fi

echo -n "Enter your password: "
read -s password

echo

function urlencode() {
	printf %s "${1}" | jq -sRr @uri
}

env_file=~/.ssh/bl_env
cookie=$(urlencode "${company}"),$(urlencode "${username}"):"${password}"
mkdir -p ~/.ssh
touch "${env_file}"
chmod 0600 "${env_file}"
echo "AUTH_COOKIE='$(echo -n "${cookie}" | base64 -w 0)'" > "${env_file}"
echo "BASE_URI='https://p1.realtime.eu/rest/'" >> "${env_file}"

cat >> "${env_file}" <<'EOF'

add_default_header() {
        local -n arr="$1"
        local header="$2"

        noHeaderExists=true
        for arg in "${arr[@]}"; do

                # Split header name from header value.
                IFS=':' read -a h <<< "$header"
                IFS=':' read -a arg <<< "$arg"
                if [ "${h[0]}" = "${arg[0]}" ]; then
                        noHeaderExists=false
                        break
                fi
        done

        if $noHeaderExists; then
                arr+=("-H" "$header")
        fi
}

bl() {
        args=("${@}")

        add_default_header args 'Authorization: Basic '"${AUTH_COOKIE}"
        add_default_header args 'Accept: application/json'
        add_default_header args 'Content-Type: application/json'

        curl -s "${BASE_URI}""${args[@]}"
}

EOF

 # Make sure only the local user can access this information.
chmod 0400 "${env_file}"

# Check login
source "${env_file}"
if bl user/current 2> /dev/null | grep employer > /dev/null; then
	echo "Login successful"
	if ! grep "$env_file" ~/.bashrc; then
		echo -e '\n\n# BlinkLink CLI\nsource '"$env_file"'\n\n' >> ~/.bashrc
	fi
	exit 0
else
	echo "Login failed"
	echo "Try again...."
	$0
fi
