class Building < ApplicationRecord
  attr_accessor :is_create_history

  has_many :histories

  validates :reference, presence: true

  after_create :create_history
  after_update :create_history

  def self.import(csv)
    require "csv"
    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
      return if row.headers.index(:address).nil? || row.headers.index(:zip_code).nil? || row.headers.index(:city).nil? || row.headers.index(:country).nil?
      ImportCsvJob.perform_later(row.to_hash, "buildings")
    end
  end

  def create_history
    History.create!(manager_name: self.manager_name, building_id: self.id ) if self.is_create_history
  end
end
