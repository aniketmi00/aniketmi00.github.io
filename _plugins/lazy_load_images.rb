# Add native lazy-loading and async decoding to post images.
#
# The first image in a document is left eager: it's usually above the fold and
# often the LCP element, and lazy-loading it would delay the largest paint.
# Every image after it is deferred until it approaches the viewport.

# frozen_string_literal: true
require 'nokogiri'

Jekyll::Hooks.register [:notes], :post_convert do |doc|
  lazy_load_images(doc)
end

Jekyll::Hooks.register [:pages], :post_convert do |doc|
  next unless doc.path.start_with?('_pages/')
  lazy_load_images(doc)
end

def lazy_load_images(doc)
  parsed_doc = Nokogiri::HTML::DocumentFragment.parse(doc.content)
  images = parsed_doc.css('img')
  return if images.empty?

  images.each_with_index do |img, index|
    # Respect an explicit loading attribute if the author set one.
    img.set_attribute('loading', index.zero? ? 'eager' : 'lazy') unless img.attribute('loading')
    img.set_attribute('decoding', 'async') unless img.attribute('decoding')
  end

  doc.content = parsed_doc.inner_html
end
