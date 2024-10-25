require 'rails_helper'

RSpec.describe Poster do
    before(:each) do
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

        @posters = Poster.all
    end

    describe 'class methods' do
        it 'counts posters' do
            expect(Poster.poster_count).to eq(4)
        end

        it 'searches for posters by name' do
            poster_by_name = Poster.search_by_name("ter")

            expect(poster_by_name.map(&:name)).to eq(["DISASTER", "TERRIBLE"])
        end

        it 'searches for posters by max and min price' do
            poster_by_max_price = Poster.search_by_max_price(99)
            poster_by_min_price = Poster.search_by_min_price(99)

            expect(poster_by_max_price.map(&:name)).to eq(["DISASTER", "TERRIBLE"])
            expect(poster_by_max_price.map(&:price)).to eq([89, 40])
            expect(poster_by_min_price.map(&:name)).to eq(["MEDIOCRITY", "HOPELESSNESS"])
            expect(poster_by_min_price.map(&:price)).to eq([127, 112])
        end

        it 'sorts posters by created_at date' do
            sorted_ascending = Poster.sort_asc
            sorted_descending = Poster.sort_desc

            expect(sorted_ascending[0].name).to eq("DISASTER")
            expect(sorted_ascending[1].name).to eq("TERRIBLE")
            expect(sorted_ascending[2].name).to eq("MEDIOCRITY")
            expect(sorted_ascending[3].name).to eq("HOPELESSNESS")

            expect(sorted_descending[0].name).to eq("HOPELESSNESS")
            expect(sorted_descending[1].name).to eq("MEDIOCRITY")
            expect(sorted_descending[2].name).to eq("TERRIBLE")
            expect(sorted_descending[3].name).to eq("DISASTER")
        end
    end

    describe Poster, type: :model do
        it {should validate_presence_of(:name)}
        it {should validate_uniqueness_of(:name)}
        it {should validate_presence_of(:description)}
        it {should validate_presence_of(:year)}
        it {should validate_numericality_of(:year).only_integer}
        it {should validate_presence_of(:price)}
        it {should validate_numericality_of(:price)}
    end
end