class Building < ApplicationRecord
  validates :reference, presence: true

  def self.import(csv)
    require "csv"

    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
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
    end
  end
end
