class CsvProcessorService
  def initialize(file)
    @file = file
  end

  def process_csv
    CSV.foreach(@file.path, headers: true) do |row|
      process_row(row['name'])
    end
  end

  private

  def process_row(name)
    ProcessKeywordWorker.perform_async(name)
    # You can add more processing logic if needed
  end
end