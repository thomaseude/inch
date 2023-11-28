require 'rails_helper'

RSpec.describe Building, type: :model do

  let(:csv_file) do
    require 'csv'
    csv_string = CSV.generate do |csv|
      csv << ["reference","address","zip_code","city","country","manager_name"]
      csv << ["1","10 Rue La bruyère","75009","Paris","France","Martin Faure"]
      csv << ["2","40 Rue René Clair","75018","Paris","France","Martin Faure"]
    end
  end

  let(:csv_create) do
    require 'csv'
    csv_string = CSV.generate do |csv|
      csv << ["reference","address","zip_code","city","country","manager_name"]
      csv << ["3","11 Rue La bruyère","75009","Paris","France","Martin Faure"]
      csv << ["4","10 Rue La bruyère","75010","Paris","France","Martin Faure"]
      csv << ["5","10 Rue La bruyère","75009","Le Havre","France","Martin Faure"]
      csv << ["6","10 Rue La bruyère","75009","Paris","Spain","Martin Faure"]
      csv << ["7","10 Rue La bruyère","75009","Paris","France","Martin Faure"]
    end
  end

  let(:csv_update) do
    require 'csv'
    csv_string = CSV.generate do |csv|
      csv << ["2","12  rue de la boétie","75008","Paris","France","Martin Faure"] #update all when reference exist
      csv << ["1","10 Rue La bruyère","75009","Paris","France","Thomas EUDE"] #update manager_name when address exist
    end
  end



  describe 'Import CSV' do
    context "Create Building instance if different address (street + zip + city + country)" do
      it "CREATE Building" do
        # import init => create
        Building.import(csv_file)
        expect(Building.count).to eq(2)

        # Change info into address => create
        Building.import(csv_create)
        expect(Building.count).to eq(7)

        expect(Building.first.reference).to eq("1")
        expect(Building.first.address).to eq("10 Rue La bruyère")
        expect(Building.first.zip_code).to eq("75009")
        expect(Building.first.city).to eq("Paris")
        expect(Building.first.country).to eq("France")
        expect(Building.first.manager_name).to eq("Martin Faure")
      end
    end

    context "Update Building instance if address (street + zip + city + country) is the same" do
      it "UPDATE Building" do
        Building.import(csv_update)

        expect(Building.count).to eq(7)

        expect(Building.first.reference).to eq("1")
        expect(Building.first.address).to eq("10 Rue La bruyère")
        expect(Building.first.zip_code).to eq("75009")
        expect(Building.first.city).to eq("Paris")
        expect(Building.first.country).to eq("France")
        expect(Building.first.manager_name).to eq("Thomas EUDE")
      end
    end
  end
end
