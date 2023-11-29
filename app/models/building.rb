class Building < ApplicationRecord
  validates :reference, presence: true
  has_many :histories

  def self.import(csv)
    require "csv"
    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
      return if row.headers.index(:address).nil? || row.headers.index(:zip_code).nil? || row.headers.index(:city).nil? || row.headers.index(:country).nil?
      ImportCsvJob.perform_later(row.to_hash, "buildings")
    end
  end
end
