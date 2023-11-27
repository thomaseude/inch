FactoryBot.define do
  factory :building do
    reference { "1" }
    address { "10 Rue La bruyère" }
    zip_code { "75009" }
    city { "Paris" }
    country { "France" }
    manager_name { "Martin Faure" }
  end
end
