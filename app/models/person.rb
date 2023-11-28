class Person < ApplicationRecord
  validates :reference, presence: true

  def self.import(csv)
    require "csv"

    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
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
  end
end
