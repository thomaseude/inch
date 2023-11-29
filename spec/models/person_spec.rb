require 'rails_helper'

require 'csv'
require 'tempfile'

RSpec.describe Person, type: :model do

  let(:csv_file) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
        csv << ["1","Henri","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
        csv << ["2","Jean","Durand","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
      end)
      file.rewind
    end
  end

  let(:csv_create) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
        csv << ["3","Henri","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
        csv << ["4","Thomas","Durand","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
        csv << ["5","Thomas","EUDE","0123336789","0663456789","jdurand@gmail.com","40 Rue René Clair"]
      end)
      file.rewind
    end
  end

  let(:csv_update) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","firstname","lastname","home_phone_number","mobile_phone_number","email","address"]
        csv << ["1","Pierre","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
        csv << ["2","Jean","Durand","0102030405","0663456789","jdurand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jdurand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jean-durand@gmail.com","40 Rue René Clair"]
        csv << ["2","Jean","Durand","0102030405","0602030405","jdurand@gmail.com","42 Rue René Clair"]
        csv << ["1","Pierre","Dupont","0123456789","0623456789","p.dupont@gmail.com","10 Rue La bruyère"]
        csv << ["1","Pierre","Dupont","0123456789","0623456789","h.dupont@gmail.com","10 Rue La bruyère"]
      end)
      file.rewind
    end
  end

  let(:csv_building) do
    Tempfile.new('csv').tap do |file|
      file.write(CSV.generate do |csv|
        csv << ["reference","address","zip_code","city","country","manager_name"]
        csv << ["2","12 rue de la boétie","75008","Paris","France","Martin Faure"]
        csv << ["1","10 Rue La bruyère","75009","Paris","France","Thomas EUDE"]
      end)
      file.rewind
    end
  end

  describe 'Import CSV' do

    it "is invalid without a reference" do
      person = Person.new(reference: "")
      expect(person).not_to be_valid
      expect(person.errors[:reference]).to include("can't be blank")
    end

    context "Create Person instance if reference is not founded" do
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

    context "Update Person instance if reference is founded" do
      it "UPDATE Person" do
        Person.import(csv_file)
        Person.import(csv_create)
        Person.import(csv_update)

        expect(Person.count).to eq(5)

        expect(Person.first.reference).to eq("1")
        expect(Person.first.firstname).to eq("Pierre")
        expect(Person.first.lastname).to eq("Dupont")
        expect(Person.first.home_phone_number).to eq("0123456789")
        expect(Person.first.mobile_phone_number).to eq("0623456789")
        expect(Person.first.email).to eq("p.dupont@gmail.com")
        expect(Person.first.address).to eq("10 Rue La bruyère")
      end
    end

    context "If upload building file, it must not update or create new instance" do
      it "Only Import Person" do
        Person.import(csv_file)
        Person.import(csv_building)

        expect(Person.count).to eq(2)

        expect(Person.first.reference).to eq("1")
        expect(Person.first.firstname).to eq("Henri")
        expect(Person.first.lastname).to eq("Dupont")
        expect(Person.first.home_phone_number).to eq("0123456789")
        expect(Person.first.mobile_phone_number).to eq("0623456789")
        expect(Person.first.email).to eq("h.dupont@gmail.com")
        expect(Person.first.address).to eq("10 Rue La bruyère")
      end
    end
  end
end
