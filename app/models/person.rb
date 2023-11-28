class Person < ApplicationRecord
  validates :reference, presence: true

  def self.import(csv)
    require "csv"
    CSV.foreach(csv, headers: :first_row, header_converters: :symbol) do |row|
      return if row.headers.index(:firstname).nil? || row.headers.index(:lastname).nil?
      ImportCsvJob.perform_later(row.to_hash, "persons")
    end
  end
end
