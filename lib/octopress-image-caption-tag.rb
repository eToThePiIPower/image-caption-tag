require 'octopress-image-caption-tag/version'
require 'liquid'

# Title: Simple Image tag for Jekyll
# Authors: Charles Beynon https://eulerpi.io
#          Brandon Mathis http://brandonmathis.com
#          Felix Schäfer, Frederic Hemberger
#

module Octopress
  module Tags
    module ImageCaptionTag
      module ImageCaptionFunctions
        def parse_sizes(raw_size)
          if /\s*(?<w>\d+%?)\s+(?<h>\d+%?)/ =~ raw_size
            @width = w
            @height = h
          elsif @class.rstrip == 'right' || @class.rstrip == 'left'
            @width = '33%'
          else
            @width = '100%'
          end
        end

        def parse_title(raw_title)
          if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ raw_title
            @title  = title
            @alt    = alt
          else
            /(?:"|')(?<titlealt>[^"']+)?(?:"|')/ =~ raw_title
            @title = titlealt
            @alt = titlealt
          end
        end

        def absolute_sized_figure
          <<-EOS.gsub(/^ {10}/, '') # gsubm is to pretty up source by indenting
          <figure class='image-caption image-caption-absolute #{@class.rstrip}'>
            <a class='image-popup' href='#{@img}'>
              <img class='caption' src='#{@img}' width='#{@width}' height='#{@height}' title='#{@title}' alt='#{@alt}'>
            </a>
            <figcaption class='caption-text'>
              #{@caption}
            </figcaption>
          </figure>
          EOS
        end

        def relative_sized_figure
          <<-EOS.gsub(/^ {10}/, '') # gsubm is to pretty up source by indenting
          <figure class='image-caption #{@class.rstrip}'>
            <a class='image-popup' href='#{@img}'>
              <img class='caption' src='#{@img}' width='100%' height='100%' title='#{@title}' alt='#{@alt}'>
            </a>
            <figcaption class='caption-text'>
              #{@caption}
            </figcaption>
          </figure>
          EOS
        end
      end

      class Tag < Liquid::Tag
        include ImageCaptionFunctions
        @img = nil
        @title = nil
        @class = ''
        @width = ''
        @height = ''

        def initialize(tag_name, markup, tokens)
          if %r{(?<classname>\S.*\s+)?(?<protocol>https?://|/)(?<url>\S+)(?<sizes>\s+\d+%?\s+\d+%?)?(?<title>\s+.+)?} =~ markup
            @class = classname || 'center'
            @img = "#{protocol}#{url}"
            @title = title.strip if title
            parse_sizes(sizes)
            parse_title(@title)
          end
          super
        end

        def render(context)
          super
          @caption = @title
          if @img && @width[-1] == '%' # Relative width, so width goes on outer span
            relative_sized_figure
          elsif @img # Absolute width, so width goes on the img tag and text span gets sytle-width:@width-15;
            absolute_sized_figure
          else
            'Error processing input, expected syntax: {% imgcap [class name(s)] /url/to/image [width height] [title [alt]] %}'
          end
        end
      end

      class Block < Liquid::Block
        include ImageCaptionFunctions
        @img = nil
        @title = nil
        @class = ''
        @width = ''
        @height = ''

        def initialize(tag_name, markup, tokens)
          if %r{(?<classname>\S.*\s+)?(?<protocol>https?://|/)(?<url>\S+)(?<sizes>\s+\d+%?\s+\d+%?)?(?<title>\s+.+)?} =~ markup
            @class = classname || 'center'
            @img = "#{protocol}#{url}"
            @title = title.strip if title
            parse_sizes(sizes)
            parse_title(@title)
          end
          super
        end

        def render(context)
          site = context.registers[:site]
          converter = site.find_converter_instance(Jekyll::Converters::Markdown)
          @caption = converter.convert(super).lstrip.rstrip
          if @img && @width[-1] == '%' # Relative width, so width goes on outer span
            relative_sized_figure
          elsif @img # Absolute width, so width goes on the img tag and text span gets sytle-width:@width-15;
            absolute_sized_figure
          else
            'Error processing input, expected syntax: {% imgcaption [class name(s)] /url/to/image [width height] [title [alt]] %} Caption Text {% endimgcaption %}'
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('imgcap', Octopress::Tags::ImageCaptionTag::Tag)
Liquid::Template.register_tag('imgcaption', Octopress::Tags::ImageCaptionTag::Block)

if defined? Octopress::Docs
  Octopress::Docs.add(
    name:        'Octopress Image Caption Tag',
    gem:         'octopress-image-caption-tag',
    description: 'A tag to create images with pretty captions for Jekyll and Octopress blogs',
    path:        File.expand_path(File.join(File.dirname(__FILE__), '../')),
    source_url:  'https://github.com/eToThePiIPower/octopress-image-caption-tag',
    version:     Octopress::Tags::ImageCaptionTag::VERSION
  )
end
