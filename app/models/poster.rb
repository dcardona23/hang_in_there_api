class Poster < ApplicationRecord
    def self.search_by_name(input)
        where("name ILIKE ?", "%#{input}%")
    end

    def self.search_by_max_price(input)
        where("price <= ?", input)
    end

    def self.search_by_min_price(input)
        where("price >= ?", input)
    end
end