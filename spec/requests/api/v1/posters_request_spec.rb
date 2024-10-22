require 'rails_helper'

















































describe "Posters API" do
    it "can get one poster by its id" do
        id = Poster.create(name: "MEDIOCRITY", description: "Dreams are just that—dreams.", price: 127.00, year: 2021, vintage: false, img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8").id
    
        get "/api/v1/posters/#{id}"
    
        poster = JSON.parse(response.body, symbolize_names: true)
    
        expect(response).to be_successful

            expect(poster).to have_key(:id)
            expect(poster[:id]).to be_an(Integer)
    
            expect(poster).to have_key(:name)
            expect(poster[:name]).to be_a(String)
    
            expect(poster).to have_key(:description)
            expect(poster[:description]).to be_a(String)
    
            expect(poster).to have_key(:price)
            expect(poster[:price]).to be_a(Float)

            expect(poster).to have_key(:vintage)
            expect(poster[:vintage]).to be_in([true, false])

            expect(poster).to have_key(:img_url)
            expect(poster[:img_url]).to be_a(String)

    end
end
















































