require 'rails_helper'

RSpec.describe Person, type: :model do

  let(:csv_file) do
    require "csv"
    CSV.generate do |csv|
      csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
      csv << ["1","Henri","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
      csv << ["2","Jean","Durand","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
    end
  end

  let(:csv_create) do
    require "csv"
    CSV.generate do |csv|
      csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
      csv << ["3","Henri","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
      csv << ["4","Thomas","Durand","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
      csv << ["5","Thomas","EUDE","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
    end
  end

  let(:csv_update) do
    require "csv"
    CSV.generate do |csv|
      csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
      csv << ["1","Pierre","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
      csv << ["2","Jean","Durand","0102030405","0663456789","jdurand@gmail.com","40 Rue René Clair"]
      csv << ["2","Jean","Durand","0102030405","0602030405","jdurand@gmail.com","40 Rue René Clair"]
      csv << ["2","Jean","Durand","0102030405","0602030405","jean-durand@gmail.com","40 Rue René Clair"]
      csv << ["2","Jean","Durand","0102030405","0602030405","jean-durand@gmail.com","42 Rue René Clair"]
    end
  end

  describe 'Import CSV' do
    context "Create Person instance if different address (street + zip + city + country)" do
      it "CREATE Person" do
        # import init => create
        Person.import(csv_file)
        expect(Person.count).to eq(2)

        # Change info into address => create
        Person.import(csv_create)
        expect(Person.count).to eq(5)

        expect(Person.first.reference).to eq("1")
        expect(Person.first.firstname).to eq("Henri")
        expect(Person.first.lastname).to eq("Dupont")
        expect(Person.first.home_phone_number).to eq("0123456789")
        expect(Person.first.mobile_phone_number).to eq("0623456789")
        expect(Person.first.email).to eq("h.dupont@gmail.com")
        expect(Person.first.address).to eq("10 Rue La bruyère")
      end
    end

    context "Update Person instance if address (street + zip + city + country) is the same" do
      it "UPDATE Person" do
        Person.import(csv_update)

        expect(Person.count).to eq(5)

        expect(Person.first.reference).to eq("1")
        expect(Person.first.firstname).to eq("Pierre")
        expect(Person.first.lastname).to eq("Dupont")
        expect(Person.first.home_phone_number).to eq("0123456789")
        expect(Person.first.mobile_phone_number).to eq("0623456789")
        expect(Person.first.email).to eq("h.dupont@gmail.com")
        expect(Person.first.address).to eq("10 Rue La bruyère")
      end
    end
  end
end
