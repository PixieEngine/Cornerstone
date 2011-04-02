require 'rubygems'
require 'mechanize'
require 'action_view'

include ActionView::Helpers::TextHelper

agent = Mechanize.new

method_xpath = "/html/body/section[2]/div/div/article/div[2]/div[2]/div[2]/div[7]/div[2]/div/dl/dt/a | /html/body/section[2]/div/div/article/div[2]/div[2]/div[2]/div[7]/div[2]/dl/dt/a"
description_xpath = "/html/body/section[2]/div/div/article/div[2]/div[2]/div[2]/div[1]/p"
usage_path = "/html/body/section[2]/div/div/article/div[2]/div[2]/div[2]/div[2]/p/code"
param_xpath = "/html/body/section[2]/div/div/article/div[2]/div[2]/div[2]/div[3]/dl"

objects = %w[Boolean Number String Array Object Function RegExp Date]

File.open("src/stubs.coffee", 'wb') do |file|
  objects.each do |object|
    page = agent.get "https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/#{object}"

    method_links = page.search method_xpath
    
    method_links.each do |method_link|
      method_name = method_link.content
      
      method_page = agent.click(method_link)
      
      description = method_page.search(description_xpath).text
      
      example_usage = method_page.search(usage_path).to_s

      params = method_page.search(param_xpath).map do |param|
        word_wrap "@param #{param.search("dt").text} #{param.search("dd").text}"
      end.join("\n")

      documentation = <<-eof
###*
#{word_wrap description}

#{example_usage}
#{params}
@name #{method_name}
@methodOf #{object}#
###
      eof
      
      puts documentation
      
      file.write documentation
    end
  end
end
