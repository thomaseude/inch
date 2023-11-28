require 'rails_helper'

require 'csv'
require 'tempfile'

RSpec.describe Building, type: :model do


  let(:csv_file) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","address","zip_code","city","country","manager_name"]
        csv << ["1","10 Rue La bruyère","75009","Paris","France","Martin Faure"]
        csv << ["2","40 Rue René Clair","75018","Paris","France","Martin Faure"]
      end)
      file.rewind
    end
  end

  let(:csv_create) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","address","zip_code","city","country","manager_name"]
        csv << ["3","11 Rue La bruyère","75009","Paris","France","Martin Faure"]
        csv << ["4","10 Rue La bruyère","75010","Paris","France","Martin Faure"]
        csv << ["5","10 Rue La bruyère","75009","Le Havre","France","Martin Faure"]
        csv << ["6","10 Rue La bruyère","75009","Paris","Spain","Martin Faure"]
        csv << ["7","10 Rue La bruyère","75009","Paris","France","Martin Faure"]
      end)
      file.rewind
    end
  end

  let(:csv_update) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","address","zip_code","city","country","manager_name"]
        csv << ["2","12 rue de la boétie","75008","Paris","France","Martin Faure"]
        csv << ["1","10 Rue La bruyère","75009","Paris","France","Thomas EUDE"]
      end)
      file.rewind
    end
  end

  let(:csv_person) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
        csv << ["1","Pierre","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
        csv << ["2","Jean","Durand","0102030405","0663456789","jdurand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jdurand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jean-durand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jean-durand@gmail.com","42 Rue René Clair"]
      end)
      file.rewind
    end
  end



  describe 'Import CSV' do

    it "is invalid without a reference" do
      building = Building.new(reference: "")
      expect(building).not_to be_valid
      expect(building.errors[:reference]).to include("can't be blank")
    end

    context "Create Building instance if new reference" do
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

    context "Update Building instance if reference exist" do
      it "UPDATE Building" do
        Building.import(csv_file)
        Building.import(csv_create)
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

    context "If upload person file, it must not update or create new instance" do
      it "Only Import Building" do
        Building.import(csv_file)
        Building.import(csv_person)

        expect(Building.count).to eq(2)

        expect(Building.first.reference).to eq("1")
        expect(Building.first.address).to eq("10 Rue La bruyère")
        expect(Building.first.zip_code).to eq("75009")
        expect(Building.first.city).to eq("Paris")
        expect(Building.first.country).to eq("France")
        expect(Building.first.manager_name).to eq("Martin Faure")
      end
    end
  end
end
