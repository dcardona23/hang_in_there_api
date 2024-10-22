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
end
















































