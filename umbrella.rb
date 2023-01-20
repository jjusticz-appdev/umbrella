p "Where are you located?"

response = gets.chomp

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + response + " &key=#{ENV.fetch("GMAPS_KEY")}"

require("open-uri")
require("json")

raw_data = URI.open(gmaps_url).read

data = JSON.parse(raw_data)

only_result = data.fetch("results").at(0)

geo = only_result.fetch("geometry").fetch("location")

lat = geo.fetch("lat")
lng = geo.fetch("lng")

p "Your coordinates are " + lat.to_s + "," + lng.to_s

dark_url = "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/" + lat.to_s + "," + lng.to_s

raw_data_dark = URI.open(dark_url).read

data_dark = JSON.parse(raw_data_dark)

temp = data_dark.fetch("currently").fetch("temperature")

p "It is currently " + temp.to_s + "°F."

now = data_dark.fetch("hourly").fetch("summary")

p "Summary: " + now

hours = data_dark.fetch("hourly").fetch("data")

counter = 1
umbrella = false

while counter < 5
  precip = (hours.at(counter).fetch("precipProbability") * 100).round
  p "In " + counter.to_s + " hours, there is a " + precip.to_s + "% chance of precipitation."
  counter = counter + 1
  if precip > 20
    umbrella = true
  end

end

if umbrella == true
  p "You might want to bring an umbrella!"
end
