#!/bin/bash

. ~/.ssh/bl_env

echo -n "Enter the user-ID you wish to set the language for: "
read user

echo -n "What language do you need? Enter 'en' for English and 'nl' for Dutch: "
read language

case "$language" in
        en)
                echo -n '{"localeID": "16"}' | bl 'user/@'"${user}"/info -X PATCH --data-binary @-
                ;;
        nl)
                echo -n '{"localeID": "1"}' | bl 'user/@'"${user}"/info -X PATCH --data-binary @-
                ;;
        *)
                echo "Unknown language provided: $language"
                exit 1
esac

