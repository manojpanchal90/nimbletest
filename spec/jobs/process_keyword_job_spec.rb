# spec/jobs/process_keyword_job_spec.rb
require 'rails_helper'
require 'sidekiq/testing'
require 'webmock/rspec'

RSpec.describe ProcessKeywordJob, type: :job do
  let(:keyword) { 'SampleKeyword' }
  let(:search_site) { Keyword::SearchSites[:google] }

  before do
    Sidekiq::Testing.fake! # Use fake mode to avoid actual job execution
  end

  it 'queues the job' do
    expect {
      ProcessKeywordJob.perform_async(keyword, search_site)
    }.to change(ProcessKeywordJob.jobs, :size).by(1)
  end

  it 'fetches and stores information using HtmlFetcherService' do
    allow(HtmlFetcherService).to receive(:new).and_return(double(fetch_and_store_information: true))

    ProcessKeywordJob.new.perform(keyword, search_site)

    expect(HtmlFetcherService).to have_received(:new).with("#{search_site}?q=#{keyword}", keyword)
  end

end
