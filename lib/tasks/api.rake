desc "api call to get hotels"

task get_google_data: :environment do
  counter = 0
  @key = ENV['GOOGLE_KEY']
  Hotel.destroy_all
  @countries = Country.all

  @countries.each do |country|
    @cities = country.cities
    @cities.each do |city|

        @country_name = country.name
        @city_name = city.name
        puts "#{@country_name} #{@city_name}"

        sleep 0.5
        counter += 1

        puts "================================="
        puts "API COUNTER #{counter}"
        puts "================================="

        hotelList_response = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{@city_name}+#{@country_name}+hotel&key=#{@key}")

        hotelList_body = JSON.parse(hotelList_response.body)
        puts hotelList_body

        @hotelListArray = hotelList_body['results']
        @hotelListArray.each do |hotel|
          if (hotel['photos'])
            @new_hotel = Hotel.new( city_id: city.id,
                                    name: hotel['name'],
                                    formatted_address: hotel['formatted_address'],
                                    rating: hotel['rating'],
                                    latitude: hotel['geometry']['location']['lat'],
                                    longitude: hotel['geometry']['location']['lng'],
                                    photo_reference: hotel['photos'][0]['photo_reference'],
                                    place_id: hotel['place_id'])

            @update_hotel = Hotel.find_by(place_id: @new_hotel.place_id)

            if @update_hotel
              @update_hotel.name = @new_hotel.name
              @update_hotel.formatted_address = @new_hotel.formatted_address
              @update_hotel.rating = @new_hotel.rating
              @update_hotel.latitude = @new_hotel.latitude
              @update_hotel.longitude = @new_hotel.longitude
              @update_hotel.photo_reference = @new_hotel.photo_reference

              @update_hotel.save
            else
              @new_hotel.save
            end
          end
        end

    end
  end

  puts "FINAL API COUNT: #{counter}"
end

task missed_hotel_data: :environment do
  counter = 0
  @key = ENV['GOOGLE_KEY']
  @cities = City.includes(:hotels).where(hotels: { id: nil })

  @cities.each do |city|

      @country_name = city.country.name
      @city_name = city.name
      puts "#{@country_name} #{@city_name}"

      sleep 0.25
      counter += 1

      puts "================================="
      puts "API COUNTER #{counter}"
      puts "================================="

      hotelList_response = HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{@city_name}+#{@country_name}+hotel&key=#{@key}")

      hotelList_body = JSON.parse(hotelList_response.body)
      puts hotelList_body

      @hotelListArray = hotelList_body['results']
      @hotelListArray.each do |hotel|
        if (hotel['photos'])
          @new_hotel = Hotel.new( city_id: city.id,
                                  name: hotel['name'],
                                  formatted_address: hotel['formatted_address'],
                                  rating: hotel['rating'],
                                  latitude: hotel['geometry']['location']['lat'],
                                  longitude: hotel['geometry']['location']['lng'],
                                  photo_reference: hotel['photos'][0]['photo_reference'],
                                  place_id: hotel['place_id'])

          @update_hotel = Hotel.find_by(place_id: @new_hotel.place_id)

          if @update_hotel
            @update_hotel.name = @new_hotel.name
            @update_hotel.formatted_address = @new_hotel.formatted_address
            @update_hotel.rating = @new_hotel.rating
            @update_hotel.latitude = @new_hotel.latitude
            @update_hotel.longitude = @new_hotel.longitude
            @update_hotel.photo_reference = @new_hotel.photo_reference

            @update_hotel.save
          else
            @new_hotel.save
          end
        end
      end

  end

end
