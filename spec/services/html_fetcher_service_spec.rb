require 'rails_helper'

RSpec.describe HtmlFetcherService, type: :service do
  let(:search_url) { 'https://www.example.com' }
  let(:keyword_name) { 'kiwitech' }

  describe '#fetch_and_store_information' do
    context 'when keyword needs refresh' do
      it 'fetches HTML content and stores information' do
        # Stubbing external dependencies
        allow(HTTParty).to receive(:get).and_return(double('response', body: '<html></html>'))

        # Set up expectations for Keyword model methods
        keyword = instance_double(Keyword)
        allow(keyword).to receive(:last_fetched_at).and_return(nil)
        allow(keyword).to receive(:update).and_return(true)
        allow(Keyword).to receive(:find_or_create_by).and_return(keyword)

        # Perform the service method
        service = HtmlFetcherService.new(search_url, keyword_name)
        allow(service).to receive(:needs_refresh?).and_return(true)

        expect(service).to receive(:fetch_html_content).and_call_original
        expect(service).to receive(:extract_links).and_call_original
        expect(service).to receive(:save_information).with(keyword, '<html></html>', 0)

        service.fetch_and_store_information
      end
    end

    context 'when keyword does not need refresh' do
      it 'does not fetch HTML content' do
        # Set up expectations for Keyword model methods
        keyword = instance_double(Keyword)
        allow(keyword).to receive(:last_fetched_at).and_return(Time.now)
        allow(Keyword).to receive(:find_or_create_by).and_return(keyword)

        # Perform the service method
        service = HtmlFetcherService.new(search_url, keyword_name)
        allow(service).to receive(:needs_refresh?).and_return(false)

        expect(service).not_to receive(:fetch_html_content)

        service.fetch_and_store_information
      end
    end

    context 'when fetching HTML content succeeds' do
      it 'saves information with correct content and links' do
        # Stubbing external dependencies
        allow(HTTParty).to receive(:get).and_return(double('response', body: '<html><a href="link1"></a><a href="link2"></a></html>'))

        # Set up expectations for Keyword model methods
        keyword = instance_double(Keyword)
        allow(keyword).to receive(:last_fetched_at).and_return(nil)
        allow(keyword).to receive(:update).and_return(true)
        allow(Keyword).to receive(:find_or_create_by).and_return(keyword)

        # Perform the service method
        service = HtmlFetcherService.new(search_url, keyword_name)
        allow(service).to receive(:needs_refresh?).and_return(true)

        expect(service).to receive(:fetch_html_content).and_call_original
        expect(service).to receive(:extract_links).and_call_original
        expect(service).to receive(:save_information).with(keyword, '<html><a href="link1"></a><a href="link2"></a></html>', 2)

        service.fetch_and_store_information
      end
    end
  end
end
