class KeywordsController < ApplicationController
  before_action :set_keyword, only: %i[ show edit update destroy ]

  # GET /keywords or /keywords.json
  def index
    @keywords = Keyword.all
  end

  # GET /keywords/1 or /keywords/1.json
  def show
  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
  end

  # POST /keywords or /keywords.json
  def create
    file = params[:file]
    if valid_csv?(file)
      import_keywords(file)
      flash[:success] = 'Keywords imported successfully.'
      redirect_to keywords_path
    else
      flash[:error] = 'Please upload a valid CSV file.'
      render :new
    end
  end

  # PATCH/PUT /keywords/1 or /keywords/1.json
  def update
    respond_to do |format|
      if @keyword.update(keyword_params)
        format.html { redirect_to keyword_url(@keyword), notice: "Keyword was successfully updated." }
        format.json { render :show, status: :ok, location: @keyword }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
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

     def import_keywords(file)
       CsvProcessorService.new(file).process_csv
     end
end
