require 'rails_helper'

















































describe "Posters API" do
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
end
















































