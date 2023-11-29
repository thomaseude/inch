class ImportCsvJob < ApplicationJob
  queue_as :default

  def perform(row, table)

    row.create()

    case table
    when "buildings"
      reference = row[:reference]
      address = row[:address]
      zip_code = row[:zip_code]
      city = row[:city]
      country = row[:country]
      manager_name = row[:manager_name]

      # UPDATE or CREATE
      building = Building.find_by(reference: reference)
      if building.nil?
        Building.create(
          reference: reference,
          address: address,
          zip_code: zip_code,
          city: city,
          country: country,
          manager_name: manager_name
        )
      else
        building.update(
          reference: reference,
          address: address,
          zip_code: zip_code,
          city: city,
          country: country,
          manager_name: manager_name
        )
      end
    when "persons"
      reference = row[:reference]
      firstname = row[:firstname]
      lastname = row[:lastname]
      home_phone_number = row[:home_phone_number]
      mobile_phone_number = row[:mobile_phone_number]
      email = row[:email]
      address = row[:address]

      # UPDATE or CREATE
      person = Person.find_by(reference: reference)
      if person.nil?
        Person.create(
          reference: reference,
          firstname: firstname,
          lastname: lastname,
          home_phone_number: home_phone_number,
          mobile_phone_number: mobile_phone_number,
          email: email,
          address: address,
        )
      else
        person.update(
          reference: reference,
          firstname: firstname,
          lastname: lastname,
          home_phone_number: home_phone_number,
          mobile_phone_number: mobile_phone_number,
          email: email,
          address: address,
        )
      end
    end
    # Do something later
  end
end
