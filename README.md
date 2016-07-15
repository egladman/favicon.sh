# [favicon.sh](https://github.com/egladman/favicon.sh)
A bash script that generates and compresses favicons of *all* variants. I'm by
no means a bash expert, so if you see an error in my ways kindly let me know.

<br>

![favicon.sh](terminal.gif "favicon.sh")

<br>

#### I went out of way to support:
- iOS 6+
- Safari Pinned Tab
- Windows Tiles

<br>

#### Dependencies
- [ImagMagick](https://www.imagemagick.org)
- [OptiPNG](http://optipng.sourceforge.net/)

<br>

#### Usage
```
./favicon.sh  -i path/to/image -o path/to/directory -c #FFFFFF -t 20
```

There are *4* options
-  `-h`  show this help text
-  `-i`  path to image (default: favicon.svg)
-  `-o`  set output directory (default: favicons)
-  `-c`  set background hex color of Windows tiles and safari pinned tab (default: #0078d7)
-  `-t`  monochrome threshold for safari pinned tab. 0 to 100 (default: 15)"

<br>

#### Example
```bash
./favicon.sh -i myImage.svg
```

<br>

#### Recommendations
- The source image should be greater than or equal to `558x558`
- Use a `.svg` for the original image

<br>

#### HTML
Insert the following lines into the head of your file

```html
<link rel="icon" type="image/x-icon" href="/path/to/favicon.ico" sizes="16x16 24x24 32x32 48x48 64x64">
<link rel="mask-icon" href="/path/to/safari-pinned-tab.svg" color="#4285F4">

<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-57.png" sizes="57x57">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-60.png" sizes="60x60">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-72.png" sizes="72x72">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-76.png" sizes="76x76">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-114.png" sizes="114x114">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-120.png" sizes="120x120">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-144.png" sizes="144x144">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-152.png" sizes="152x152">
<link rel="apple-touch-icon-precomposed" href="/path/to/favicons/favicon-180.png" sizes="180x180">

<meta name="msapplication-TileColor" content="#4285F4">
<meta name="msapplication-TileImage" content="/path/to/favicons/favicon-144.png">

<meta name="application-name" content="Foo">
<meta name="msapplication-tooltip" content="Bar">
<meta name="msapplication-config" content="/path/to/favicons/ieconfig.xml">

<link rel="icon" type="image/png" href="/path/to/favicons/favicon-32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/path/to/favicons/favicon-96.png" sizes="96x96">
<link rel="icon" type="image/png" href="/path/to/favicons/favicon-128.png" sizes="128x128">
<link rel="icon" type="image/png" href="/path/to/favicons/favicon-195.png" sizes="195x195">
<link rel="icon" type="image/png" href="/path/to/favicons/favicon-196.png" sizes="196x196">
<link rel="icon" type="image/png" href="/path/to/favicons/favicon-228.png" sizes="228x228">
```
*Make sure to change out* `Foo` *and* `Bar`.

<br>

#### Sources
- [Favicon Cheat Sheet](https://github.com/audreyr/favicon-cheat-sheet)
- [Apple Developer Docs](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/pinnedTabs/pinnedTabs.html)
- [Taylor Fausak](http://taylor.fausak.me/2015/01/27/ios-8-web-apps/)
- [Microsoft Developer Network](https://msdn.microsoft.com/en-us/windows/uwp/controls-and-patterns/tiles-and-notifications-app-assets)

<br>

#### Contributing
Contributions and/or feature requests are welcomed. Please report issues.
