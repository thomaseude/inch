FactoryBot.define do
  factory :history do
    email { "MyString" }
    home_phone_number { "MyString" }
    mobile_phone_number { "MyString" }
    address { "MyString" }
    manager_name { "MyString" }
    person { nil }
    building { nil }
  end
end
