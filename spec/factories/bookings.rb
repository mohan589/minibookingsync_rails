FactoryGirl.define do
  factory :booking do
    start_at {"2017-04-19"} 
    end_at {"2017-04-20"} 
    client_email {"myemail@client.pl"} 
    price {120}
  end
end
