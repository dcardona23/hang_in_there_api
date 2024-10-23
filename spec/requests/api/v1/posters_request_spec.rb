require 'rails_helper'

RSpec.describe "Poster API" do
it "sends a list of all posters" do
    Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
    Poster.create(name: "DEFEAT",
    description: "It's REALLY too late to start now.",
    price: 40.00,
    year: 2024,
    vintage: false,
    img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
  )
    Poster.create(name: "PROCRASTINATION",
    description: "You can't change anything.",
    price: 94.00,
    year: 2012,
    vintage: false,
    img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
  )
  get '/api/v1/posters'
  posters = JSON.parse(response.body, symbolize_names: true)
 
  expect(response).to be_successful
  expect(posters[:data].count).to eq(3)
  posters[:data].each do |poster|

    expect(poster).to have_key(:id)
    expect(poster[:id].to_i).to be_an(Integer)

    attributes = poster[:attributes]
 
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_an(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_an(String)

    expect(attributes).to have_key(:price)
    expect(attributes[:price]).to be_an(Float)

    expect(attributes).to have_key(:year)
    expect(attributes[:year]).to be_an(Integer)

    expect(attributes).to have_key(:vintage)
    expect(attributes[:vintage]).to be_in([true, false])

    expect(attributes).to have_key(:img_url)
    expect(attributes[:img_url]).to be_an(String)
  end
end

it "can add new posters" do
    poster_params = {   
                "name": "DEFEAT",
                "description": "It's too late to start now.",
                "price": 35.00,
                "year": 2023,
                "vintage": false,
                "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    created_poster = Poster.last
    #binding.pry
    expect(response).to be_successful
    expect(created_poster.name).to eq(poster_params[:name])
    expect(created_poster.description).to eq(poster_params[:description])
    expect(created_poster.price).to eq(poster_params[:price])
    expect(created_poster.year).to eq(poster_params[:year])
    expect(created_poster.vintage).to eq(poster_params[:vintage])
    expect(created_poster.img_url).to eq(poster_params[:img_url])

end

it "can ignore info that's not accepted" do
    poster_params ={ 
        "id":43,
        "name": "FAILURE",
        "description": "It's too late to start now.",
        "price": 35.00,
        "year": 2023,
        "vintage": false,
        "img_url":  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
}

headers = {"CONTENT_TYPE" => "application/json"}
post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
created_poster = Poster.last
#binding.pry
expect(response).to be_successful
expect(created_poster.name).to eq(poster_params[:name])
expect(created_poster.description).to eq(poster_params[:description])
expect(created_poster.price).to eq(poster_params[:price])
expect(created_poster.year).to eq(poster_params[:year])
expect(created_poster.vintage).to eq(poster_params[:vintage])
expect(created_poster.img_url).to eq(poster_params[:img_url])

end

    it "can get one poster by its id" do
        id = Poster.create(
            name: "MEDIOCRITY", 
            description: "Dreams are just that—dreams.", 
            price: 127.00, 
            year: 2021, 
            vintage: false, 
            img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8").id
    
        get "/api/v1/posters/#{id}"
    
        poster = JSON.parse(response.body, symbolize_names: true)
    
        expect(response).to be_successful

            expect(poster).to have_key(:data)
    
            expect(poster[:data]).to have_key(:id)
            expect(poster[:data][:id]).to be_a(Integer)

            expect(poster[:data]).to have_key(:type)
            expect(poster[:data][:type]).to eq("poster")

            expect(poster[:data]).to have_key(:attributes)

            attributes = poster[:data][:attributes]

            expect(attributes).to have_key(:description)
            expect(attributes[:description]).to be_a(String)

            expect(attributes).to have_key(:price)
            expect(attributes[:price]).to be_a(Float)

            expect(attributes).to have_key(:vintage)
            expect(attributes[:vintage]).to be_in([true, false])

            expect(attributes).to have_key(:img_url)
            expect(attributes[:img_url]).to be_a(String)
    end

    it 'can update a poster' do
        poster = Poster.create(
            name: "MEDIOCRITY", 
            description: "Dreams are just that—dreams.", 
            price: 127.00, 
            year: 2021, 
            vintage: false, 
            img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8")

        id = poster.id
    
        patch "/api/v1/posters/#{id}", params: {
            poster: {
            name: "STUPIDITY",
            description: "Reality hits hard.",
            price: 150.00,
            year: 2022,
            vintage: true,
            img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
    }
    }
    
        updated_poster = JSON.parse(response.body, symbolize_names: true)
    
        expect(response).to be_successful

        expect(updated_poster).to have_key(:data)

        expect(updated_poster[:data]).to have_key(:attributes)

        attributes = updated_poster[:data][:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to eq("STUPIDITY")

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to eq("Reality hits hard.")

        expect(attributes).to have_key(:price)
        expect(attributes[:price]).to eq(150.0)

        expect(attributes).to have_key(:vintage)
        expect(attributes[:vintage]).to eq(true)

        expect(attributes).to have_key(:year)
        expect(attributes[:year]).to eq(2022)

        expect(attributes).to have_key(:img_url)
        expect(attributes[:img_url]).to eq("https://images.unsplash.com/photo-1551993005-75c4131b6bd8")
    end

    it 'can destroy a poster by id' do
        poster = Poster.create(
            name: "MEDIOCRITY", 
            description: "Dreams are just that—dreams.", 
            price: 127.00, 
            year: 2021, 
            vintage: false, 
            img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8")

        id = poster.id

        delete "/api/v1/posters/#{id}"

        expect(response).to be_successful
        expect(response).to have_http_status(204)
    end

    it "sends a list of all posters in ascending order" do
        Poster.create(name: "REGRET",
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
        Poster.create(name: "DEFEAT",
        description: "It's REALLY too late to start now.",
        price: 40.00,
        year: 2024,
        vintage: false,
        img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
      )
        Poster.create(name: "PROCRASTINATION",
        description: "You can't change anything.",
        price: 94.00,
        year: 2012,
        vintage: false,
        img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
      )
      get '/api/v1/posters?posters?sort=desc'
      posters = JSON.parse(response.body, symbolize_names: true)
      #binding.pry
      expect(response).to be_successful
      expect(posters[:data].count).to eq(3)
      #Add tests that show created at is higher/lower
    end

end
















































