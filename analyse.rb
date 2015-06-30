require_relative 'crawl'
require 'sentimental'

Sentimental.load_defaults
analyzer = Sentimental.new

articles = search_url('intc')

scores = []

articles.each do |article|
  score = 0
  begin
    doc = Nokogiri::HTML(open(article))

    if doc
      a = doc.css('#article_body').text.split(". ")

      if a.class == Array and a.length > 0
        a.each do |sentence|
          result = analyzer.get_sentiment sentence
          case result
          when :positive
            score +=1
          when :neutral
            score
          when :negative
            score -=1
          end
          puts score
        end
      end
      scores << score
    end
  rescue
    puts 'Error!'
  end
end

average = 0
scores.each do |score|
  average += score
end

puts "\n# of Articles: " + scores.length.to_s
puts average/scores.length