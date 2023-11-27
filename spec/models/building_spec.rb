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



  describe 'Import CSV' do
    context "Create Building instance if different address (street + zip + city + country)" do
      it "CREATE Building" do
        # if street is not found
        # if zip is not found
        # if city is not found
        # if country is not found
      end
    end

    context "Update Building instance if address (street + zip + city + country) is the same" do
      it "UPDATE Building" do
      end
    end
  end
end
