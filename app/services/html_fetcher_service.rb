# app/services/html_fetcher_service.rb
require 'nokogiri'
require 'open-uri'

class HtmlFetcherService
  attr_accessor :search_url, :keyword

  def initialize(search_url, keyword)
    @search_url  = search_url
    @keyword = keyword
  end

  def fetch_and_store_information
    html_content = fetch_html_content
    doc = Nokogiri::HTML(html_content)
    #search_count = extract_search_count(doc)
    links        = extract_links(doc).size
    #binding.pry
    #search_count = extract_search_count(doc)
    #binding.pry
    save_information(html_content, links)
  end

  private

  def fetch_html_content
    begin
      response = HTTParty.get(search_url)
      response.body
    rescue StandardError => e
      # Handle error, e.g., log it or raise a custom exception
      raise "Error fetching HTML content: #{e.message}"
    end
  end

  def extract_links(doc)
    #doc = Nokogiri::HTML(html_content)
    doc.css('a').map { |link| link['href'] }
  end

  def extract_search_count(doc)
    result_stats_text = doc.css('#result-stats').text.strip
    #binding.pry
    result_number = result_stats_text.match(/(\d+)/)[1].to_i
  end

  def save_information(html_content, links)
    begin
      user = Keyword.find_or_create_by!(name: keyword) do |u|
        u.total_links = links
        u.html_content =  html_content
      end
    rescue ActiveRecord::RecordInvalid => e
      puts "Error: #{e.message}"
    end
    # Save the HTML content and links to your database or wherever you prefer
    # Example: You can create a model/table to store this information
    # Information.create(url: @url, html_content: html_content, links: links)
  end
end
