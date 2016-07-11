#!/bin/bash
# A script that generates favicons of *all* variants
# https://github.com/egladman/favicon.sh
# Licensed under Apache License 2.0
#
# Created by Eli Gladman <eli.gladman@gmail.com>
#
# Usage:
# ./favicon.sh path/to/myImage.png

red='\033[0;31m'
orange='\033[0;33m'
light_green='\033[0;32m'
nc='\033[0m' # No Color

length () {
  echo -n $1 | wc -c
}

success () {
  echo -e "${light_green}Success: ${nc}$1"
}

warning () {
  echo -e "${orange}Warning: ${nc}$1"
}

error () {
  echo -e "${red}Error: ${nc}$1 Aborting."
  exit 1
}

dependencies=(
  "convert"
  "optipng"
)

# check if dependencies are installed
for program in "${dependencies[@]}"
do
  command -v $program >/dev/null 2>&1 || {
    error "$program is not installed."
  }
done

# set default image source if argument wasn't passed in
if [ $(length $1) -eq "0" ]; then
  source_image="favicon.png"
else
  source_image=$1
fi

# if the file exists
if [ -f $source_image ]; then
  dimensions=( $(identify -format '%W %H' $source_image) )
else
  error "$source_image doesn't exist."
fi


difference=$(expr ${dimensions[0]} - ${dimensions[1]})

if [ $difference -gt 0 ]; then
  warning "$source_image is not a square image."
fi

ico_resolutions=(
  16 24 32 48 64
)

png_resolutions=(
  16 24 32 48 57 64 76 96 120 128 144 152 180 195 196 228 270 558
)

for i in "${dimensions[@]}"
do
  if [ $i -lt ${png_resolutions[-1]} ] && [[ ! $source_image =~ \.svg$ ]]; then
    warning "The image's resolution is less than the recommended ${png_resolutions[-1]}x${png_resolutions[-1]}."

    while :
    do
      read -p "Would you like to continue? ( y/N ): " response

      if [ $(length $response) -ne 0 ]; then
        # downcase user input
        response=${response,,}
      fi

      case $response in
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
  path="favicons"
else
  path=$2
fi

# create directory if it doesn't exist
if [ ! -d $path ]; then
  mkdir $path
fi

for i in "${png_resolutions[@]}"
do
  case $i in
    128)
      convert $source_image -resize ${i}x${i} $path/smalltile.png
      convert $source_image -resize ${i}x${i} $path/favicon-${i}.png
      ;;
    270)
      convert $source_image -resize ${i}x${i} $path/mediumtile.png
      ;;
    558)
      convert $source_image -resize ${i}x${i} $path/largetile.png
      convert $source_image -resize ${i}x270 $path/widetile.png
      ;;
    *)
      convert $source_image -resize ${i}x${i} $path/favicon-${i}.png
      ;;
  esac
done

# SVG vector mask for Safari 9+
convert $source_image -resize 16x16 -colorspace gray $path/icon.svg

# compress images
optipng -o7 -strip all $path/*.png >/dev/null 2>&1

files=()
for i in "${ico_resolutions[@]}"
do
  files+=($path/favicon-$i.png)
done

convert ${files[@]} $path/favicon.ico

# removes unnecessary images that were only used for the favicon.ico generation
# NOTE: some versions of "find" don't have the delete option. I might need to
# refactor the following command to accommodate additional users
find $path -type f -name '*[a-z]-[0-2||4||6][0-9].png' -delete

# generate ieconfig.xml as it's needed for Windows
echo "
<?xml version=\"1.0\" encoding=\"utf-8\"?>
  <browserconfig>
    <msapplication>
      <tile>
        <square70x70logo src=\"$path/smalltile.png\"/>
        <square150x150logo src=\"$path/mediumtile.png\"/>
        <wide310x150logo src=\"$path/widetile.png\"/>
        <square310x310logo src=\"$path/largetile.png\"/>
        <TileColor>#FFFFFF</TileColor>
      </tile>
    </msapplication>
  </browserconfig>" > $path/ieconfig.xml

success "The favicons can be found in $path"
