class ProcessKeywordWorker
  include Sidekiq::Worker

  def perform(keyword, search_site)
    # Perform your individual operation on each row here
    # For example, you can create a Keyword record
    HtmlFetcherService.new("#{search_site}?search=keyword", keyword).fetch_and_store_information
  end

  # def search_url
  #   "#{search_site}?search=keyword"
  # end
end