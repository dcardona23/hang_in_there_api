class Poster < ApplicationRecord
    def self.search_by_name(input)
        where("name ILIKE ?", "%#{input}%")
    end

    def self.search_by_max_price(max_price)
        where("price <= ?", max_price)
    end

    def self.search_by_min_price(min_price)
        where("price >= ?", min_price)
    end
end