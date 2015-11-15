# Octopress Image Caption Tag

A fork of [octopress/image-tag][img] that incorporates [Robert
Anderson's][zerosharp] technique, adds extended features, a block version,
and wraps it all up in a gem.

## Using the Tag version
```liquid
{% imgcap [right|left|center] url_or_path 200 200 ["Some Title Text" ["Some alt text"]] %}
```
Width and height can be either absolute or as a percentage. By default, width is
set to 33% for right and left aligned and 100% for centered images, and height
is auto-scaled.

If no alt text is specified, the title text is used. The title text will be used
for the caption.

## Using the Block version
```liquid
{% imgcaption [right|left|center] url_or_path 200 200 ["Some Title Text" ["Some alt text"]] %}
**Any** standard [Markdown][md] text can be used in captions using the block
version.
{% endimgcaption %}
```
The block version uses the same options as the tag version, but instead of using
the title text for the caption, a block is taken to allow Markdown formatting
in the caption text.

## Output
The output for either version is the same, and of the form:
```html
<figure class='caption-wrapper right|left|center' style='width:WIDTH'>
  <a class='image-popup' href='IMGSRC'>
    <img class='caption' src='IMGSRC' width='100%' title='TITLE' alt='ALT'>
  </a>
  <figcaption class='caption-text'>CAPTION</figcaption>
</figure>
```

## Styling
This gem does not include stylesheets for the image captions. [Robert
Anderson's][zerosharp] original blog post includes a nice example of how to
style them.


[md]: https://daringfireball.net/projects/markdown/
[img]: https://github.com/octopress/image-tag
[zerosharp]: http://blog.zerosharp.com/image-captions-for-octopress/
