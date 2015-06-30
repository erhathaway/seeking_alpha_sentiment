require 'open-uri'
require 'nokogiri'
require 'chill'
require 'mechanize'
require 'pry'





# create mechanize object
def mechanize
  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
  }
end

def search_url(stock)
  links = {}
  mechanize.get('http://www.seekingalpha.com/') do |page|
    # binding.pr.y
    search_result = page.form_with(method: "GET") do |search|
      # binding.pry
      search.q = stock
    end.submit

    # search_result.links.each do |link|
    #   puts link.text
    # end

    if link  = search_result.link_with(id: "tab_quote_headlines") # As long as there is still a nextpage link...
      analysis_page = link.click
      # binding.pry
    else # If no link left, then break out of loop
      break
    end

    if noko_obj = analysis_page.parser
      # puts analysis_page.content


      noko_obj.css('div.content_block_investment_views a').each do |link|
        link = link['href']

        if link != nil and link.include? '/article/' and not (link.include? '#comments_header')
          # binding.pry
          links[link]='http://seekingalpha.com'+link
        end 
      end
    end
  end
  links.values
end




