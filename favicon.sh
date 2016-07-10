#!/bin/bash
# A script that generates favicons of *all* variants
# https://github.com/egladman/favicon.sh
# Licensed under Apache License 2.0
#
# Created by Eli Gladman <eli.gladman@gmail.com>
#
# Usage:
# ./favicon.sh path/to/myImage.png

dependencies=(
  "convert"
)

# check if dependencies are indeed installed
for program in "${dependencies[@]}"
do
  command -v $program >/dev/null 2>&1 || {
    echo >&2 "${program} is not installed. Aborting."
    exit 1
  }
done


len=$(echo -n $1 | wc -c)

if [ $len == "0" ]; then
  src="favicon.png"
else
  src=$1
fi

if [ -f $src ]; then
  dimensions=( $(identify -format '%W %H' $src) )
else
  echo "${src} doesn't exist. Aborting"
  exit 1
fi



for i in "${dimensions[@]}"
do
  if [ $i -lt 558 ]; then
    echo "The image's dimensions are less than the 558x558 recommendations."

    while :
    do
      read -p "Would you like to continue? ( y/N ): " answer

       case $answer in
        Y|y)
          echo "yes"
          break 2
          ;;
        N|n|"")
          exit 1
          ;;
        *)
          echo "Please enter \"y\" or \"n\""
          ;;
        esac
     done

  fi
done



ico=(
  16 24 32 48 64
)

for i in "${ico[@]}"
do
  convert ${src} -resize ${i}x${i} favicon-${i}.png
done


png=(
  32 57 76 96 120 128 144 152 180 195 196 228 270 558
)

for i in "${png[@]}"
do
  case ${i} in
    128)
      convert ${src} -resize ${i}x${i} smalltile.png
      convert ${src} -resize ${i}x${i} favicon-${i}.png
      ;;
    270)
      convert ${src} -resize ${i}x${i} mediumtile.png
      ;;
    558)
      convert ${src} -resize ${i}x${i} favicon-${i}.png
      convert ${src} -resize ${i}x270 favicon-${i}.png
    *)
      convert ${src} -resize ${i}x${i} favicon-${i}.png
      ;;
  esac
done