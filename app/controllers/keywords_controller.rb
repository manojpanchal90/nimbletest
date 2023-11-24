class KeywordsController < ApplicationController
  before_action :set_keyword, only: %i[ show destroy ]
  before_action :authenticate_user!
  # GET /keywords or /keywords.json
  def index
    @keywords = Keyword.paginate(page: params[:page], per_page: 10)
  end

  # GET /keywords/1 or /keywords/1.json
  def show
  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # POST /keywords or /keywords.json
  def create
    file = params[:file]
    begin
      import_keywords(file)
      flash[:success] = 'Keywords imported successfully.'
      redirect_to keywords_path
    rescue StandardError => e
      flash[:error] = "Error importing keywords: #{e.message}"
      render :new
    end
  end

  # DELETE /keywords/1 or /keywords/1.json
  def destroy
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to keywords_url, notice: "Keyword was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @keyword = Keyword.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def keyword_params
      params.fetch(:keyword, {})
    end

    def valid_csv?(file)
      true
    end

     def import_keywords(file)
       CsvProcessor.new(file).process_csv
     end
end
