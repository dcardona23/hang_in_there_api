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

    def self.sort_asc
        order("created_at")
    end

    def self.sort_desc
       order("created_at desc")
    end

    def self.poster_count
        posters = Poster.all
        posters.count
    end
    
end