#!/bin/bash
#
# jpg2grayeps
#
# convert jpg pictures into gray eps pictures 
# (requires image magick)
#
# $Id: jpg2eps.sh,v 1.1 2001/08/03 20:17:16 klauko70 Exp $
#


# get a list of all jpg pictures in the current directory
PICTURE_LIST=$( ls *.jpg )

# convert them all
for PICTURE in $PICTURE_LIST
do
 
 NEW_NAME=$( echo $PICTURE | cut -d "." -f 1  ).eps
 echo "$PICTURE --> $NEW_NAME"
 
 convert -colors 255 -colorspace GRAY $PICTURE $NEW_NAME
 
done

