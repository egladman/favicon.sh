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
  "optipng"
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

ico=(
  16 24 32 48 64
)

png=(
  16 24 32 48 57 64 76 96 120 128 144 152 180 195 196 228 270 558
)

for i in "${dimensions[@]}"
do
  if [ $i -lt ${png[-1]} ]; then
    echo "The image's dimensions are less than the ${png[-1]}x${png[-1]} recommendations."

    while :
    do
      read -p "Would you like to continue? ( y/N ): " answer

      if [ $(length $answer) -ne 0 ]; then
        # downcase user input
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

if [ $(length $2) -eq "0" ]; then
  dir="favicons"
else
  dir=$2
fi

# create directory if it doesn't exist
if [ ! -d $dir ]; then
  mkdir $dir
fi

for i in "${png[@]}"
do
  case ${i} in
    128)
      convert $src -resize ${i}x${i} ${dir}/smalltile.png
      convert $src -resize ${i}x${i} ${dir}/favicon-${i}.png
      ;;
    270)
      convert $src -resize ${i}x${i} ${dir}/mediumtile.png
      ;;
    558)
      convert $src -resize ${i}x${i} ${dir}/largetile.png
      convert $src -resize ${i}x270 ${dir}/widetile.png
      ;;
    *)
      convert $src -resize ${i}x${i} ${dir}/favicon-${i}.png
      ;;
  esac
done

# compress images
optipng -o2 -strip all $dir/*.png >/dev/null 2>&1

files=()
for i in "${ico[@]}"
do
  files+=($dir/favicon-$i.png)
done

convert ${files[@]} ${dir}/favicon.ico

echo -e "
<?xml version="1.0" encoding="utf-8"?>
  <browserconfig>
    <msapplication>
      <tile>
        <square70x70logo src="${dir}/smalltile.png"/>
        <square150x150logo src="${dir}mediumtile.png"/>
        <wide310x150logo src="${dir}/widetile.png"/>
        <square310x310logo src="${dir}/largetile.png"/>
        <TileColor>#FFFFFF</TileColor>
      </tile>
    </msapplication>
  </browserconfig>" > ${dir}/ieconfig.xml
