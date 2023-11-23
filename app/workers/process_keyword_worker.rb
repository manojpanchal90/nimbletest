class ProcessKeywordWorker
  include Sidekiq::Worker

  def perform()
    # Perform your individual operation on each row here
    # For example, you can create a Keyword record
    url = params[:url]
    HtmlFetcherService.new(url).fetch_and_store_information
end