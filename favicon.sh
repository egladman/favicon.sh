#!/bin/bash
# A script that generates favicons of *all* variants
# https://github.com/egladman/favicon.sh
# Licensed under Apache License 2.0
#
# Created by Eli Gladman <eli.gladman@gmail.com>
#
# Usage:
# ./favicon.sh -i image.png -o path/to/directory

red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 3)
purple=$(tput smul)
normal=$(tput sgr0 rmul)

success () {
  printf '%s\n' "${green}Success: $normal$1" >&2
}

warning () {
  printf '%s\n' "${orange}Warning: $normal$1" >&2
}

error () {
  printf '%s\n' "${red}Error: $normal$1 Aborting." >&2
}

length () {
  printf $1 | wc -c
}

dependencies=(
  "convert"
  "optipng"
  "getopts"
)

# check if dependencies are installed
for program in "${dependencies[@]}"
do
  command -v $program >/dev/null 2>&1 || {
    error "$program is not installed."
  }
done

usage="${0##*/} [-h] [-i path/to/image] [-o path/to/directory] [-c #bb0000] [-t 30] -- program to generate favicons
where:
  -h  show this help text
  -i  path to image (default: favicon.svg)
  -o  set output directory (default: favicons)
  -c  set background hex color of Windows tiles and Safari pinned tab (default: #0078d7)
  -t  monochromatic threshold for Safari pinned tab on a scale from 0 to 100 (default: 15)"

path="favicons"
source_image="favicon.svg"
color="#0078d7"
threshold="15"

while getopts ':hc:i:t:o:' option; do
  case $option in
    h)
      printf '%s\n' "$usage" >&2
      exit
      ;;
    i)
      source_image=$OPTARG
      ;;
    o)
      path=$OPTARG
      ;;
    c)
      color=$OPTARG
      ;;
    t)
      threshold=$OPTARG
      ;;
    :)
      error "missing argument for -$OPTARG."
      printf '%s\n' "$usage" >&2
      exit 1
      ;;
   \?)
      error "illegal option -$OPTARG."
      printf '%s\n' "$usage" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# if the file exists
if [ -f $source_image ]; then
  dimensions=( $(identify -format '%W %H' $source_image) )
else
  error "$source_image doesn't exist."
  exit 1
fi

# difference in source images width and height
difference=$(expr ${dimensions[0]} - ${dimensions[1]})

if [ $difference -gt 0 ]; then
  warning "$source_image is not a square image. Favicons will be distorted."
fi

ico_sizes=(
  16 24 32 48 64
)

png_sizes=(
  16 24 32 48 57 60 64 72 76 96 114 120 128 144 152 180 195 196 228 270 558
)

for i in "${dimensions[@]}"
do
  if [ $i -lt ${png_sizes[-1]} ] && [[ ! $source_image =~ \.svg$ ]]; then
    min_size=${png_sizes[-1]}x${png_sizes[-1]}
    warning "The image's size is less than the recommended $min_size resolution."

    while :
    do
      read -p "Would you like to continue? ( y/N ): " response

      # downcase user input
      if [ $(length $response) -ne 0 ]; then
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
          printf '%s\n' "Please enter \"y\" or \"n\""
          ;;
      esac
    done
  fi
done

# create directory if it doesn't exist
if [ ! -d $path ]; then
  mkdir $path
fi

for i in "${png_sizes[@]}"
do
  # NOTE: This could use some refactoring. It's rather redundant
  case $i in
    128)
      convert $source_image -background none -resize $(expr $i / 2)x$(expr $i / 2) -gravity center -extent ${i}x${i} $path/smalltile.png
      convert $source_image -resize ${i}x${i} $path/favicon-$i.png
      ;;
    270)
      convert $source_image -background none -resize $(expr $i / 3)x$(expr $i / 3) -gravity center -extent ${i}x${i} $path/mediumtile.png
      ;;
    558)
      convert $source_image -background none -resize $(expr $i / 3)x$(expr $i / 3) -gravity center -extent ${i}x${i} $path/largetile.png
      convert $source_image -background none -resize $(expr $i / 6)x$(expr $i / 6) -gravity center -extent ${i}x270 $path/widetile.png
      ;;
    *)
      convert $source_image -resize ${i}x${i} $path/favicon-$i.png
      ;;
  esac
done

# svg vector mask for Safari 9+
convert $source_image -monochrome -threshold $threshold% -transparent white -resize 16x16 $path/safari-pinned-tab.svg

# compress images
if optipng -o7 -strip all $path/*.png >/dev/null 2>&1; then
  success "Images compressed."
else
  error "A problem occured during compression."
  exit 1
fi

files=()
for i in "${ico_sizes[@]}"
do
  files+=($path/favicon-$i.png)
done

# consolidate multiple .png into .ico
if convert ${files[@]} $path/favicon.ico; then
  success "The favicons can be found in directory: $path"
else
  error "A problem occured while generating the .ico image."
  exit 1
fi

# NOTE: some versions of "find" don't have the delete option. I might need to
# refactor the following command to accommodate additional users

# removes unnecessary images that were only used for the favicon.ico generation
find $path -type f -name '*[a-z]-[0-2||4||6][0-9].png' -delete

# generate ieconfig.xml as it's needed for Windows
printf "<?xml version=\"1.0\" encoding=\"utf-8\"?>
  <browserconfig>
    <msapplication>
      <tile>
        <square70x70logo src=\"/path/to/smalltile.png\"/>
        <square150x150logo src=\"/path/to/mediumtile.png\"/>
        <wide310x150logo src=\"/path/to/widetile.png\"/>
        <square310x310logo src=\"/path/to/largetile.png\"/>
        <TileColor>$color</TileColor>
      </tile>
    </msapplication>
  </browserconfig>" > $path/ieconfig.xml

printf '\n%s\n' "${purple}Use the following HTML${normal}" >&2

# generate html
printf '%s\n' "
<link rel=\"icon\" type=\"image/x-icon\" href=\"/path/to/favicon.ico\" sizes=\"16x16 24x24 32x32 48x48 64x64\">
<link rel=\"mask-icon\" href=\"/path/to/safari-pinned-tab.svg\" color=\"$color\">

<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-57.png\" sizes=\"57x57\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-60.png\" sizes=\"60x60\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-72.png\" sizes=\"72x72\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-76.png\" sizes=\"76x76\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-114.png\" sizes=\"114x114\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-120.png\" sizes=\"120x120\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-144.png\" sizes=\"144x144\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-152.png\" sizes=\"152x152\">
<link rel=\"apple-touch-icon-precomposed\" href=\"/path/to/$path/favicon-180.png\" sizes=\"180x180\">

<meta name=\"msapplication-TileColor\" content=\"$color\">
<meta name=\"msapplication-TileImage\" content=\"/path/to/$path/favicon-144.png\">

<meta name=\"application-name\" content=\"Foo\">
<meta name=\"msapplication-tooltip\" content=\"Bar\">
<meta name=\"msapplication-config\" content=\"/path/to/$path/ieconfig.xml\">

<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-32.png\" sizes=\"32x32\">
<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-96.png\" sizes=\"96x96\">
<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-128.png\" sizes=\"128x128\">
<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-195.png\" sizes=\"195x195\">
<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-196.png\" sizes=\"196x196\">
<link rel=\"icon\" type=\"image/png\" href=\"/path/to/$path/favicon-228.png\" sizes=\"228x228\">" >&2
