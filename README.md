# [favicon.sh](https://github.com/egladman/favicon.sh)
A bash script that generates and compresses favicons of *all* variants. I'm by
no means a bash expert, so if you see an error in my ways kindly let me know. I
have no intention of making this POSIX compliant.

<!-- <br>

#### Support
- iOS 6+ -->


<br>

#### Dependencies
- [ImagMagick](https://www.imagemagick.org)
- [OptiPNG](http://optipng.sourceforge.net/)

<br>

#### Usage
```bash
./favicon.sh <image> <output_path>
```

<br>

#### Example
```bash
./favicon.sh myImage.png foo
```

<br>

#### Default Behavior
- If executed without any arguments the script looks for `favicon.png`. If
`favicon.png` doesn't exist the script exits.

- Generated favicons are saved to `/favicons` if a second argument isn't provided

- Currently you cannot specify a output directory without first specifying an
image path

<br>

#### Recommendations
- The source image should be greater than or equal to `558x558`
- Use a `.svg` for the source image

<br>

#### HTML
Insert the following lines into the head of your file

```html
<link rel="icon" type="image/x-icon" href="/path/to/favicon.ico" sizes="16x16 24x24 32x32 48x48 64x64"/>

<link rel='mask-icon' href='/path/to/icon.svg' color='#FFFFFF'>

<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-57.png" sizes="57x57">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-60.png" sizes="60x60">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-72.png" sizes="72x72">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-76.png" sizes="76x76">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-114.png" sizes="114x114">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-120.png" sizes="120x120">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-144.png" sizes="144x144">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-152.png" sizes="152x152">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicon-180.png" sizes="180x180">

<meta name="msapplication-TileColor" content="#FFFFFF">
<meta name="msapplication-TileImage" content="/path/to/favicon-144.png">

<meta name="application-name" content="Foo">
<meta name="msapplication-tooltip" content="Tooltip">
<meta name="msapplication-config" content="/path/to/ieconfig.xml">

<link rel="icon" type="image/png" href="/path/to/favicon-32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/path/to/favicon-96.png" sizes="96x96">
<link rel="icon" type="image/png" href="/path/to/favicon-128.png" sizes="128x128">

<link rel="icon" type="image/png" href="/path/to/favicon-195.png" sizes="195x195">
<link rel="icon" type="image/png" href="/path/to/favicon-196.png" sizes="196x196">
<link rel="icon" type="image/png" href="/path/to/favicon-228.png" sizes="228x228">
```

<br>

#### Sources
- [Favicon Cheat Sheet](https://github.com/audreyr/favicon-cheat-sheet)
- [Safari Pinned Tab Icons](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/pinnedTabs/pinnedTabs.html)
- [Taylor Fausak](http://taylor.fausak.me/2015/01/27/ios-8-web-apps/)
