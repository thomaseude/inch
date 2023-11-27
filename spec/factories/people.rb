FactoryBot.define do
  factory :person do
    reference { "MyString" }
    email { "MyString" }
    home_phone_number { "MyString" }
    mobile_phone_number { "MyString" }
    firstname { "MyString" }
    lastname { "MyString" }
    address { "MyString" }
  end
end
