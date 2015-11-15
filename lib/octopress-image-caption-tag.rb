require "octopress-image-caption-tag/version"
require "liquid"

# Title: Simple Image tag for Jekyll
# Authors: Brandon Mathis http://brandonmathis.com
#          Felix Schäfer, Frederic Hemberger
#

module Octopress
  module Tags
    module ImageCaptionTag
      class Tag < Liquid::Tag
        @img = nil
        @title = nil
        @class = ''
        @width = ''
        @height = ''

        def initialize(tag_name, markup, tokens)
          if markup =~ /(\S.*\s+)?(https?:\/\/|\/)(\S+)(\s+\d+%?\s+\d+%?)?(\s+.+)?/i
            @class = $1 || ''
            @img = $2 + $3
            if $5
              @title = $5.strip
            end
            if $4 =~ /\s*(\d+%?)\s+(\d+%?)/
              @width = $1
              @height = $2
            elsif @class.rstrip == "right" or @class.rstrip == "left"
              @width = "33%"
            else
              @width = "100%"
            end
            if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @title
              @title  = title
              @alt    = alt
            else
              @alt    = @title.gsub!(/"/, '&#34;') if @title
            end
          end
          super
        end

        def render(context)
          super
          if @img && @width[-1] == "%" # Relative width, so width goes on outer span
            "<figure class='#{('caption-wrapper ' + @class).rstrip}' style='width:#{@width};'>" +
              "<a class='image-popup' href='#{@img}'>" +
              "<img class='caption' src='#{@img}' width='100%' height='100%' title='#{@title}' alt='#{@alt}'>" +
              "</a>" +
              "<figurecaption class='caption-text'>#{@title}</figurecaption>" +
              "</figure>"
          elsif @img # Absolute width, so width goes on the img tag and text span gets sytle-width:@width-15;
            "<figure class='#{('caption-wrapper ' + @class).rstrip}'>" +
              "<a class='image-popup' href='#{@img}'>" +
              "<img class='caption' src='#{@img}' width='#{@width}px' height='#{@height}px' title='#{@title}' alt='#{@alt}'>" +
              "</a>" +
              "<figurecaption class='caption-text' style='width:#{@width.to_i - 10}px;'>#{@title}</figurecaption>" +
              "</figure>"
          else
            "Error processing input, expected syntax: {% imgcap [class name(s)] /url/to/image [width height] [title [alt]] %}"
          end
        end
      end

      class Block < Liquid::Block
        @img = nil
        @title = nil
        @class = ''
        @width = ''
        @height = ''

        def initialize(tag_name, markup, tokens)
          if markup =~ /(\S.*\s+)?(https?:\/\/|\/)(\S+)(\s+\d+%?\s+\d+%?)?(\s+.+)?/i
            @class = $1 || ''
            @img = $2 + $3
            if $5
              @title = $5.strip
            end
            if $4 =~ /\s*(\d+%?)\s+(\d+%?)/
              @width = $1
              @height = $2
            elsif @class.rstrip == "right" or @class.rstrip == "left"
              @width = "33%"
            else
              @width = "100%"
            end
            if /(?:"|')(?<title>[^"']+)?(?:"|')\s+(?:"|')(?<alt>[^"']+)?(?:"|')/ =~ @title
              @title  = title
              @alt    = alt
            else
              @alt    = @title.gsub!(/"/, '&#34;') if @title
            end
          end
          super
        end

        def render(context)
          @caption = super
          site = context.registers[:site]
          converter = site.getConverterImpl(Jekyll::Converters::Markdown)
          if @img && @width[-1] == "%" # Relative width, so width goes on outer span
            "<figure class='#{('caption-wrapper ' + @class).rstrip}' style='width:#{@width};'>" +
              "<a class='image-popup' href='#{@img}'>" +
              "<img class='caption' src='#{@img}' width='100%' height='100%' title='#{@title}' alt='#{@alt}'>" +
              "</a>" +
              "<figurecaption class='caption-text'>#{@caption}</figurecaption>" +
              "</figure>"
          elsif @img # Absolute width, so width goes on the img tag and text span gets sytle-width:@width-15;
            "<figure class='#{('caption-wrapper ' + @class).rstrip}'>" +
              "<a class='image-popup' href='#{@img}'>" +
              "<img class='caption' src='#{@img}' width='#{@width}px' height='#{@height}px' title='#{@title}' alt='#{@alt}'>" +
              "</a>" +
              "<figurecaption class='caption-text' style='width:#{@width.to_i - 10}px;'>#{converter.convert(@caption)}</figurecaption>" +
              "</figure>"
          else
            "Error processing input, expected syntax: {% imgcaption [class name(s)] /url/to/image [width height] [title [alt]] %} Caption Text {% endimgcaption %}"
          end
        end
      end

    end
  end
end

Liquid::Template.register_tag('imgcap', Octopress::Tags::ImageCaptionTag::Tag)
Liquid::Template.register_tag('imgcaption', Octopress::Tags::ImageCaptionTag::Block)

if defined? Octopress::Docs
  Octopress::Docs.add({
    name:        "Octopress Image Caption Tag",
    gem:         "octopress-image-caption-tag",
    description: "A tag to create images with pretty captions for Jekyll and Octopress blogs",
    path:        File.expand_path(File.join(File.dirname(__FILE__), "../")),
    source_url:  "https://github.com/eToThePiIPower/octopress-image-caption-tag",
    version:     Octopress::Tags::ImageCaptionTag::VERSION
  })
end
