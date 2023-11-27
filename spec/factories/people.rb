FactoryBot.define do
  factory :person do
    reference { "1" }
    email { "Henri" }
    home_phone_number { "Dupont" }
    mobile_phone_number { "0123456789" }
    firstname { "0623456789" }
    lastname { "h.dupont@gmail.com" }
    address { "10 Rue La bruyère" }
  end
end
