class CsvProcessor

  MIN_RECORDS = 1
  MAX_RECORDS = 100
  EXPECTED_HEADER = 'Name'
  VALID_CSV_EXTENSIONS = %w[.csv]

  def initialize(file)
    @file = file
    validate_file_format
  end

  def process_csv

    validate_csv_header
    validate_csv_records

    CSV.foreach(@file.path, headers: true) do |row|
      process_row(row['Name'])
    end
  end

  private

  def validate_csv_header
    header = CSV.open(@file.path, 'r', &:readline)
    raise 'Invalid CSV header' unless header.include?(EXPECTED_HEADER)
  end

  def validate_csv_records
    record_count = `wc -l < #{@file.path}`.to_i
    raise 'Invalid number of records in CSV' unless (MIN_RECORDS..MAX_RECORDS).include?(record_count)
  end

  def validate_file_format
    extension = File.extname(@file.original_filename).downcase
    raise 'Invalid file format. Please upload a CSV file.' unless VALID_CSV_EXTENSIONS.include?(extension)
  end

  def process_row(keyword)
    ProcessKeywordWorker.new.perform(keyword, Keyword::SearchSites[:google])
    # You can add more processing logic if needed
  end

end