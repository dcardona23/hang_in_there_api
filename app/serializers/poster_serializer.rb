class PosterSerializer
    include JSONAPI::Serializer
    set_id :id
    attributes :name, :description, :price, :year, :vintage, :img_url
end