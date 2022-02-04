#!/bin/bash

# chalet-screenshot - Is a script that take screenshots using imagemagick.
# Version 1: Capture full screen.
# Versoin 2: Sava to a specified directory.
# Version 3: Crop the image.
# Version 3: Copy to clipboard.
#
#
#
# Author - Marcos Chalet
#

CUT=0
COPY=0

PATH_SAVE=~/screenshots
NAME=screenshot
EXTENSION=png
INDICE=-1
CUT_LOCATION=

HELP="
Use: $(basename "$0") [OPTIONS]

OPTIONS:
    -c, --copy    Copy the image to clipboard
    -p, --path    Change directory.
    -h, --help    Show help.
    -x, --cut     Select image area.

EXAMPLE:
    -p ~/set/new/path
    -x 300x300+10+10
    -p ~/set/new/path -x 300x300+10+10
"

# Selecting run options.
while test -n "$1"
do
    case "$1" in
        -c | --copy)
            COPY=1
        ;;

        -p | --path)
            shift
            PATH_SAVE="$1"
        ;;

        -x | --cut)
            shift
            CUT=1
            CUT_LOCATION="$1"
        ;;

        -h | --help)
            echo "$HELP"
            exit 0
        ;;

        *)
            echo "Invalid input: $1"
            echo "Run \"$(basename $0) -h\" to get help."
            exit 1
        ;;
    esac

    # Moving the command queue to ($n).
    shift
done

##### GETTING THE ID IN THE NAME OF LAST SCREENSHOT #####

# Select screenshots taken.
INDICE=$(ls -v -r "$PATH_SAVE" | grep screenshot)

# List the ids of the screenshots already taken.
INDICE=$(echo "$INDICE" | grep -o '[0-9]*' | sed -z 's/\n/, /g')

# Get the last id.
INDICE=$(echo "$INDICE" | cut -d , -f -1)

# Put as the value of the next id.
INDICE=$((INDICE+1))

###################################################


# Take a screenshot at the indicated location.
import -window root "$PATH_SAVE"/"$NAME"_"$INDICE"."$EXTENSION"

# Crop the image.
test "$CUT" = 1 && magick -extract "$CUT_LOCATION"\
                                      "$PATH_SAVE"/"$NAME"_"$INDICE"."$EXTENSION"\
                                      "$PATH_SAVE"/"$NAME"_"$INDICE"."$EXTENSION"

# Copy to clipboard.
test "$COPY" = 1 && xclip -selection clipboard -t image/png\
                      -i "$PATH_SAVE"/"$NAME"_"$INDICE"."$EXTENSION"

