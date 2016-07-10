# favicon.sh
A bash script that generates and compresses favicons of *all* variants. It
requires [ImagMagick](https://www.imagemagick.org) and
[OptiPNG](http://optipng.sourceforge.net/)

#### Usage
```bash
./favicon.sh myImage.png
```

If favicon.sh is executed without an argument the script looks for `favicon.png`.
If `favicon.png` doesn't exist the script exits.

It is recommended that the original image be greater than or equal to `558x558`

Generated favicons are saved in `/favicons`

<br>

Once the favicons are generated refer [here](https://github.com/audreyr/favicon-cheat-sheet)
