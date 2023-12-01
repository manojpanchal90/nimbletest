# spec/services/csv_processor_spec.rb
require 'rails_helper'

RSpec.describe CsvProcessor do
  let(:valid_csv_path) { Rails.root.join('spec', 'fixtures', 'correct.csv') }
  let(:invalid_csv_path) { Rails.root.join('spec', 'fixtures', 'incorrect.csv') }


  describe '#process_csv' do
    context 'with a valid CSV file' do
      it 'processes the CSV file successfully' do

            # Mocking the file object with a test double
        file_double = double(path: valid_csv_path, original_filename: 'correct.csv')
        csv_processor = CsvProcessor.new(file_double)

        # Set up a spy on ProcessKeywordJob to check the arguments later
        allow(ProcessKeywordJob).to receive(:perform_async)

        # Ensure the CsvProcessor processes the CSV file without errors
        expect { csv_processor.process_csv }.not_to raise_error

        # Check that the ProcessKeywordJob received the expected arguments
        expect(ProcessKeywordJob).to have_received(:perform_async).with('kiwitech', Keyword::SearchSites[:google])
      end
    end

    context 'with an invalid CSV file' do
      it 'raises an error for invalid CSV header' do
        file_double = double(path: invalid_csv_path, original_filename: 'incorrect.csv')
        csv_processor = CsvProcessor.new(file_double)

        expect { csv_processor.process_csv }.to raise_error('Invalid CSV header')
      end

      it 'raises an error for invalid number of records in CSV' do
        invalid_limitation = Rails.root.join('spec', 'fixtures', 'incorrect_number.csv')
        file_double = double(path: invalid_limitation, original_filename: 'incorrect_number.csv')
        csv_processor = CsvProcessor.new(file_double)

        expect { csv_processor.process_csv }.to raise_error('Invalid number of records in CSV')
      end

    end
  end
end
