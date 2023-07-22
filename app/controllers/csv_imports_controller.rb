class CsvImportsController < ApplicationController
  
  def new; end

  def create
    if params[:file].present?
      process_csv_file(params[:file])
      redirect_to root_path, notice: 'CSV data imported successfully!'
    else
      flash[:alert] = 'Please select a CSV file to import.'
      render :new
    end
  end

  private

  def process_csv_file(file)
    CSV.foreach(file.path) do |row|
  
    end
  end
end
