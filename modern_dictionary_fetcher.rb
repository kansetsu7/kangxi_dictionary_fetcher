require 'pry'
require 'nokogiri'
require 'open-uri'

class ModernDictionaryFetcher
  class << self
    def characters(strokes)
      puts "Fetch for strokes: #{strokes}...."
      Nokogiri::HTML(URI.open("https://www.twpen.com/bihua/#{strokes}"))
        .then { |doc| doc.xpath("//ul[contains(@class, 'site-textlist')]//li//a") }
        .map(&:text)
        .join
    end

    def write_to_file(data)
      puts "Write to file..."
      file = File.open('result/modern_dictionary.txt', 'w')
      data.each do |strokes, chars|
        file.write("#{strokes.to_s.rjust(2)}, #{chars}\n")
      end
    end

    def dump_all_strokes_characters
      (1..36).to_a
        .reject { |strokes| strokes == 34 }
        .map { |strokes| [strokes, characters(strokes)] }
        .then { |data| write_to_file(data) }

      puts "Done!"
    end
  end
end
