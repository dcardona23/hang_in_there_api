class PosterSerializer
    include JSONAPI::Serializer
    set_id :id
    attributes :name, :description, :price, :year, :vintage, :img_url


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