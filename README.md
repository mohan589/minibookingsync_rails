# README

This is a Ruby on Rails API application that allows for a simple booking.

* Database creation
```bash
rails db:setup
```

* Running
```bash
rails server
```

* Running test suite
```bash
bundle exec rspec
```

* Examples of requests (cURL formatted)
```bash
curl -X POST -d "api_token=j6hd9@l664HDv2agh&name=VillaRenoma&daily_rate=150" http://localhost:3000/rentals

curl -X GET -d "api_token=j6hd9@l664HDv2agh" http://localhost:3000/rentals

curl -X GET -d "api_token=j6hd9@l664HDv2agh" http://localhost:3000/rentals/1/bookings 

curl -X POST -d "api_token=j6hd9@l664HDv2agh&start_at=2017-09-19&end_at=2017-09-20&price=120&client_email=a@a.pl" http://localhost:3000/rentals/1/bookings

curl -X PATCH -d "api_token=j6hd9@l664HDv2agh&client_email=myemail123@client.pl" http://localhost:3000/rentals/5/bookings/1
```
