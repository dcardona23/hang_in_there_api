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
    expect(poster[:id]).to be_an(String)

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

      expect(response).to be_successful
      expect(created_poster.name).to eq(poster_params[:name])
      expect(created_poster.description).to eq(poster_params[:description])
      expect(created_poster.price).to eq(poster_params[:price])
      expect(created_poster.year).to eq(poster_params[:year])
      expect(created_poster.vintage).to eq(poster_params[:vintage])
      expect(created_poster.img_url).to eq(poster_params[:img_url])
  end

  it "will not let you create or update a poster with a duplicate name" do
    Poster.create(name: "REGRET",
    description: "It's REALLY too late to start now.",
    price: 40.00,
    year: 2024,
    vintage: false,
    img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    )

    post "/api/v1/posters", params: {
      poster: {
        name: "REGRET",
        description: "You will never be happy.",
        price: 124.00,
        year: 2023,
        vintage: false,
        img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
      }
    }

    poster = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
  end

  it "will return a 422 error if a user fails to include required attributes" do
    missing_attributes = {
      description: "You'll never succeed.",
      year: 1990, 
      vintage: true,
      img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }

    post "/api/v1/posters", params: { poster: missing_attributes }

    JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
  end

  it "will not let a user update a poster with a duplicate name" do
    poster = Poster.create(name: "REGRET",
    description: "It's REALLY too late to start now.",
    price: 40.00,
    year: 2024,
    vintage: false,
    img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    )

    id = poster.id

    Poster.create(name: "PROCRASTINATION",
      description: "You can't change anything.",
      price: 94.00,
      year: 2012,
      vintage: false,
      img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    )

    patch "/api/v1/posters/#{id}", params: {
      poster: {
      name: "PROCRASTINATION",
      description: "Reality hits hard.",
      price: 150.00,
      year: 2022,
      vintage: true,
      img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
      }
  }

  updated_poster = JSON.parse(response.body, symbolize_names: true)

  expect(response.status).to eq(422)

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
      expect(poster[:data][:id]).to be_a(String)

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

  it 'returns an error if an id does not exist' do
    poster = Poster.create(name: "REGRET",
    description: "It's REALLY too late to start now.",
    price: 40.00,
    year: 2024,
    vintage: false,
    img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    )

    id = poster.id

    get "/api/v1/posters/#{id}4"

    expect(response.status).to eq(404)

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
    get '/api/v1/posters?sort=asc'
    posters = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(posters[:data].count).to eq(3)
    expect(posters[:data][0][:attributes][:name]).to eq("REGRET")
    expect(posters[:data][1][:attributes][:name]).to eq("DEFEAT")
    expect(posters[:data][2][:attributes][:name]).to eq("PROCRASTINATION")
  end

  it "sends a list of all posters in descending order" do
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
    
    get '/api/v1/posters?sort=desc'
    posters = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(posters[:data].count).to eq(3)
    expect(posters[:data][0][:attributes][:name]).to eq("PROCRASTINATION")
    expect(posters[:data][1][:attributes][:name]).to eq("DEFEAT")
    expect(posters[:data][2][:attributes][:name]).to eq("REGRET")
  end

    it 'searches for posters by name' do
      Poster.create(name: "DISASTER",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

      Poster.create(name: "TERRIBLE",
      description: "It's REALLY too late to start now.",
      price: 40.00,
      year: 2024,
      vintage: false,
      img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      Poster.create(name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      Poster.create(name: "HOPELESSNESS",
      description: "Stay in your comfort zone; it's safer.",
      price: 112.00,
      year: 2020,
      vintage: true,
      img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      posters = Poster.all
      poster_by_name = posters.search_by_name("ter")
      expect(poster_by_name.map(&:name)).to eq(["DISASTER", "TERRIBLE"])
    end

  it 'filters results by query parameters' do
      Poster.create(name: "DISASTER",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

      Poster.create(name: "TERRIBLE",
      description: "It's REALLY too late to start now.",
      price: 40.00,
      year: 2024,
      vintage: false,
      img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      Poster.create(name: "MEDIOCRITY",
      description: "Dreams are just that—dreams.",
      price: 127.00,
      year: 2021,
      vintage: false,
      img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      Poster.create(name: "HOPELESSNESS",
      description: "Stay in your comfort zone; it's safer.",
      price: 112.00,
      year: 2020,
      vintage: true,
      img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")

      get '/api/v1/posters?name=ter'
      posters = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(posters[:data].count).to eq(2)

      get '/api/v1/posters?max_price=99.99'
      posters = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(posters[:data].count).to eq(2)

      get '/api/v1/posters?min_price=99.99'
      posters = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(posters[:data].count).to eq(2)
  end
  
end
















































