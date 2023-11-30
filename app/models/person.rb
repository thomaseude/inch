class Person < ApplicationRecord
  attr_accessor :is_create_history

  has_many :histories, dependent: :destroy

  validates :reference, presence: true

  after_create :create_history
  after_update :create_history

  def self.import(csv)
    require "csv"
    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
      return if row.headers.index(:firstname).nil? || row.headers.index(:lastname).nil?
      ImportCsvJob.perform_later(row.to_hash, "persons")
    end
  end

  def create_history
    History.create!(
      email: self.email,
      home_phone_number: self.home_phone_number,
      mobile_phone_number: self.mobile_phone_number,
      address: self.address,
      person_id: self.id
    ) if self.is_create_history
  end
end
