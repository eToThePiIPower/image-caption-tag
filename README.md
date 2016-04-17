# Octopress Image Caption Tag

A fork of [octopress/image-tag][img] that incorporates [Robert
Anderson's][zerosharp] technique, adds extended features, a block version,
and wraps it all up in a gem.

## Using the Tag version
```liquid
{% imgcap [right|left|center] [custom classes] url_or_path 200 200 ["Some Title Text" ["Some alt text"]] %}
```
Width and height can be either absolute or as a percentage. By default, width is
set to 33% for right and left aligned and 100% for centered images, and height
is auto-scaled.

If no alt text is specified, the title text is used. The title text will be used
for the caption.

## Using the Block version
```liquid
{% imgcaption [right|left|center] [custom classes] url_or_path 200 200 ["Some Title Text" ["Some alt text"]] %}
**Any** standard [Markdown][md] text can be used in captions using the block
version.
{% endimgcaption %}
```
The block version uses the same options as the tag version, but instead of using
the title text for the caption, a block is taken to allow Markdown formatting
in the caption text.

## Output
The output for either version is the same, except that CAPTION in the version
form as wrapped in a <p> and contains markup. If absolute sizes are used, the
`.image-caption-absolute` class is added to the enclosing figure.
```html
<figure class='image-caption [image-caption-absolute] right|left|center [custom classes]'>
  <a class='image-popup' href='IMGSRC'>
    <img class='caption' src='IMGSRC' width='100%' title='TITLE' alt='ALT'>
  </a>
  <figcaption class='caption-text'>CAPTION</figcaption>
</figure>
```

## Styling
This gem does not include stylesheets for the image captions. A basic sample
stylesheet is shown below that can be adapted to your site. As of version 
0.0.6 inline widths were removed from the enclosing figure to allow for
better responsive design.
```scss
figure.image-caption {
  // Sizing only done on larger tablets and larger
  @media only screen and (min-width: 480px) {
    &.right {
      float: right;
      width: 33%;
    }
    &.left {
      float: left;
      width: 33%;
    }
    &.center {
      margin: 0 auto;
    }
    // Example of custom class
    &.half {
      width: 50%;
    }
    &.image-caption-absolute {
      width:unset;
    }
  }
  // Center image within the figure
  img {
    display: block;
    margin: 0 auto;
  }
  // Image should fill space given when not specifically sized
  &:not(.image-caption-absolute) {
    img {
      width: 100%;
      height: 100%;
    }
  }
  figcaption {
    text-align: center;
    font-style: italic;
    font-size: 0.75em;
  }
}
```

[md]: https://daringfireball.net/projects/markdown/
[img]: https://github.com/octopress/image-tag
[zerosharp]: http://blog.zerosharp.com/image-captions-for-octopress/
