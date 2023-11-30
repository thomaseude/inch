class ImportCsvJob < ApplicationJob
  queue_as :default

  def perform(row, table)

    case table
    when "buildings"
      attributes = {
        reference: row[:reference],
        address: row[:address],
        zip_code: row[:zip_code],
        city: row[:city],
        country: row[:country],
        manager_name: row[:manager_name],
        is_create_history: true
      }

      # UPDATE or CREATE
      building = Building.find_by(reference: attributes[:reference])
      if building.nil?
        Building.create!(attributes)
      else
        attributes.delete(:manager_name) if building.histories.find_by(manager_name: attributes[:manager_name]).present?
        building.update(attributes)
      end
    when "persons"
      attributes = {
        reference: row[:reference],
        firstname: row[:firstname],
        lastname: row[:lastname],
        home_phone_number: row[:home_phone_number],
        mobile_phone_number: row[:mobile_phone_number],
        email: row[:email],
        address: row[:address],
        is_create_history: true
      }

      # UPDATE or CREATE
      person = Person.find_by(reference: attributes[:reference])
      if person.nil?
        Person.create(attributes)
      else
        attributes.delete(:email) if person.histories.find_by(email: attributes[:email]).present?
        attributes.delete(:home_phone_number) if person.histories.find_by(home_phone_number: attributes[:home_phone_number]).present?
        attributes.delete(:mobile_phone_number) if person.histories.find_by(mobile_phone_number: attributes[:mobile_phone_number]).present?
        attributes.delete(:address) if person.histories.find_by(address: attributes[:address]).present?

        person.update(attributes)
      end
    end
    # Do something later
  end
end
