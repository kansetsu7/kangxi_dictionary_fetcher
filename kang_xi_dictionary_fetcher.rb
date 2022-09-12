require 'pry'
require 'nokogiri'
require 'open-uri'

class KangXiDictionaryFetcher
  class << self
    def extract_utf8_char(text)
      char, code = text.split(' ')
      code&.size == 4 ? char : nil
    end

    def extract_page_num_from_doc(doc)
      return nil unless found_data?(doc)
      doc.xpath("//div[@id='cornerbody2']//font[@color='Red']").last.children.to_s.gsub(/^.+\//, '').to_i
    end

    def found_data?(doc)
      doc.xpath("//font[@color='red' and contains(text(), '抱歉，查無資料')]").empty?
    end

    def find_pages(strokes)
      Nokogiri::HTML(URI.open("https://kangxizidian.com/kxbihua/#{strokes}"))
        .then { |doc| extract_page_num_from_doc(doc) }
    end

    def strokes_and_pages
      puts "Find valid strokes..."
      (1..63).to_a
        .map { |strokes| [strokes, find_pages(strokes)] }
        .reject { |strokes, pages| pages.nil? }
        .to_h
    end

    def find_texts(strokes, pages)
      puts "Fetch for strokes: #{strokes}...."
      Range.new(1, pages).reduce([]) do |memo, page_num|
        puts "  page #{page_num}"
        memo + Nokogiri::HTML(URI.open("https://kangxizidian.com/search/index.php?stype=TotalStk&sword=#{strokes}&detail=n&Page=#{page_num}"))
          .then { |doc| doc.xpath("//div[contains(@style,'width:64px') and contains(@style,'font-size:18px')]") }
          .map  { |node| node.children.text }
          .map  { |text| extract_utf8_char(text) }
          .compact
      end
    end

    def write_to_file(data)
      puts "Write to file..."
      file = File.open('result/kang_xi_dictionary.txt', 'w')
      data.each do |strokes, chars|
        file.write("#{strokes.to_s.rjust(2)}, #{chars}\n")
      end
    end

    def dump_all_valid_strokes_characters
      strokes_and_pages
        .map { |s, ps| [s, find_texts(s, ps).join] }
        .reject { |s, chars| chars.empty? }
        .then { |data| write_to_file(data) }

      puts "Done!"
    end
  end
end
