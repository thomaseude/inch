class CreateHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :histories do |t|
      t.string :email
      t.string :home_phone_number
      t.string :mobile_phone_number
      t.string :address
      t.string :manager_name
      t.references :person, null: true, foreign_key: true
      t.references :building, null: true, foreign_key: true

      t.timestamps
    end
  end
end
