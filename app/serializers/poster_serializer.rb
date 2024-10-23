class PosterSerializer
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