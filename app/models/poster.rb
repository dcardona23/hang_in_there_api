class Poster < ApplicationRecord
    validates :name, :presence => true, :uniqueness => true
    validates :description, :presence => true
    validates :year, :presence => true, :numericality => { :only_integer => true}
    validates :price, :presence => true, :numericality => true
    validates :vintage, :inclusion => {:in => [true,false]}


    def self.search_by_name(input)
        where("name ILIKE ?", "%#{input}%").order("name")
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