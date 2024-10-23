class PosterSerializer
<<<<<<< HEAD
    include JSONAPI::Serializer
    set_id :id
    attributes :name, :description, :price, :year, :vintage, :img_url
    
=======
    def self.format_posters(posters)
        posters.map do |poster|
        {
            data: [
                id: poster.id,
                type: "poster",
                attributes: {
                    name: poster.name,
                    description: poster.description,
                    price: poster.price,
                    year: poster.year,
                    vintage: poster.vintage,
                    img_url: poster.img_url
                }
            ],
            meta: {
                count: posters.count
            }
        }
    end
    end

>>>>>>> 9d0be1b2c003f16d0684e0c6d644759e4e4f0f72
    def self.format_poster(poster)
        {
            data: {
                id: poster.id,
                type: "poster",
                attributes: {
                    name: poster.name,
                    description: poster.description,
                    price: poster.price,
                    year: poster.year,
                    vintage: poster.vintage,
                    img_url: poster.img_url
                }
            }
        }
    end

end