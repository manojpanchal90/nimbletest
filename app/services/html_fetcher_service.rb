# app/services/html_fetcher_service.rb
require 'nokogiri'
require 'open-uri'

class HtmlFetcherService
  attr_reader :search_url, :keyword_name

  def initialize(search_url, keyword_name)
    @search_url = search_url
    @keyword_name = keyword_name
    #@keyword_service = KeywordService.new
  end

  def fetch_and_store_information
    keyword = find_or_create_keyword
    return unless needs_refresh?(keyword)

    html_content = fetch_html_content
    links = extract_links(Nokogiri::HTML(html_content)).size
    save_information(keyword, html_content, links)
  end

  private

  def fetch_html_content
    HTTParty.get(search_url).body
  rescue StandardError => e
    handle_fetch_error(e)    
  end

  def extract_links(doc)
    doc.css('a').map { |link| link['href'] }
  end

  def handle_fetch_error(error)
    raise "Error fetching HTML content: #{error.message}"
  end

  def save_information(keyword, html_content, links)
    success = keyword.update(
      total_links: links,
      html_content: html_content,
      last_fetched_at: Time.now
    )

    handle_save_error(keyword) unless success
  end

  def handle_save_error(keyword)
    puts "Error saving information for '#{keyword.name}': #{keyword.errors.full_messages.to_sentence}"
  end

  def find_or_create_keyword
    Keyword.find_or_create_by(name: keyword_name)
  end

  def needs_refresh?(keyword)
    last_fetched_at = keyword.last_fetched_at
    cached_period_hours = ENV['CACHED_PERIOD'].to_i.hours
    last_fetched_at.nil? || last_fetched_at < (Time.now - cached_period_hours)
  end


end
