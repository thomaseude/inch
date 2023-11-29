class History < ApplicationRecord
  belongs_to :person
  belongs_to :building
end
