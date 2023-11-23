# app/services/html_fetcher_service.rb
require 'nokogiri'
require 'open-uri'

class HtmlFetcherService
  def initialize(url)
    @url = url
  end

  def fetch_and_store_information
    html_content = fetch_html_content
    links = extract_links(html_content)

    save_information(html_content, links)
  end

  private

  def fetch_html_content
    begin
      response = HTTParty.get(@url)
      response.body
    rescue StandardError => e
      # Handle error, e.g., log it or raise a custom exception
      raise "Error fetching HTML content: #{e.message}"
    end
  end

  def extract_links(html_content)
    doc = Nokogiri::HTML(html_content)
    doc.css('a').map { |link| link['href'] }
  end

  def save_information(html_content, links)
    # Save the HTML content and links to your database or wherever you prefer
    # Example: You can create a model/table to store this information
    # Information.create(url: @url, html_content: html_content, links: links)
  end
end
Use the service i