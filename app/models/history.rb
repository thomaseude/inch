class History < ApplicationRecord
  belongs_to :person, optional: true
  belongs_to :building, optional: true
end
