class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    building = Building.find(params[:id])
    building.update!(params_building)
    redirect_to buildings_path, notice: "Your building has been updated ✅"
  end

  def import
    file = params[:import][:file]
    Building.import(file.path)
    redirect_to buildings_path, notice: "Your building are loading ⏳"
  end

  private

  def params_building
    params.require(:building).permit(:reference, :address, :zip_code, :city, :country, :manager_name)
  end
end
