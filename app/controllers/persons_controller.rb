class PersonsController < ApplicationController

  def index
    @persons = Person.all
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    person = Person.find(params[:id])
    person.update!(params_person)
    redirect_to persons_path, notice: "Your person has been updated ✅"
  end

  def import
    file = params[:import][:file]
    Person.import(file.path)
    redirect_to persons_path, notice: "Your person are loading ⏳"
  end

  private

  def params_person
    params.require(:person).permit(:reference, :firstname, :lastname, :email, :home_phone_number, :mobile_phone_number, :address)
  end
end
