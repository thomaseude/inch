class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    building = Building.find(params[:id])

    building.update!(
      reference: params_building[:reference],
      address: params_building[:address],
      zip_code: params_building[:zipcode],
      city: params_building[:city],
      country: params_building[:country],
      manager_name: params_building[:manager_name]
    )

    redirect_to buildings_path
  end

  def import
    file = params[:import][:file]
    Building.import(file.path)
    redirect_to buildings_path
  end

  private

  def params_building
    params.require(:building).permit(:reference, :address, :zip_code, :city, :country, :manager_name)
  end
end
