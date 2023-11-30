class ProcessKeywordJob
  include Sidekiq::Job

  def perform(keyword, search_site)
    search_url = "#{search_site}?q=#{keyword}"
    HtmlFetcherService.new(search_url, keyword).fetch_and_store_information
  end
end