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

length () {
  echo -n $1 | wc -c
}

if [ $(length $1) -eq "0" ]; then
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

      if [ $(length $answer) -ne 0 ]; then
        answer=${answer,,}
      fi

      case $answer in
        y|yes)
          break 2
          ;;
        n|no|"")
          exit 1
          ;;
        *)
          echo "Please enter \"y\" or \"n\""
          ;;
      esac
     done

  fi
done


dir="favicons"

if [ ! -d $dir ]; then
  mkdir $dir
fi


ico=(
  16 24 32 48 64
)

for i in "${ico[@]}"
do
  convert $src -resize ${i}x${i} favicons/favicon-${i}.ico
done


png=(
  32 57 76 96 120 128 144 152 180 195 196 228 270 558
)

for i in "${png[@]}"
do
  case ${i} in
    128)
      convert $src -resize ${i}x${i} favicons/smalltile.png
      convert $src -resize ${i}x${i} favicons/favicon-${i}.png
      ;;
    270)
      convert $src -resize ${i}x${i} favicons/mediumtile.png
      ;;
    558)
      convert $src -resize ${i}x${i} favicons/largetile.png
      convert $src -resize ${i}x270 favicons/widetile.png
      ;;
    *)
      convert $src -resize ${i}x${i} favicons/favicon-${i}.png
      ;;
  esac
done
