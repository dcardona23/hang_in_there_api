class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all

        posters = posters.sort_asc if params[:sort] == "asc"
        posters = posters.sort_desc if params[:sort] == "desc"

        posters = posters.search_by_name(params[:name]) if params[:name]
        posters = posters.search_by_max_price(params[:max_price].to_f) if params[:max_price]
        posters = posters.search_by_min_price(params[:min_price].to_f) if params[:min_price]

        render json: PosterSerializer.new(posters, meta: {"count": posters.poster_count})
    end

    def create
        poster = Poster.create!(poster_params)
        render json: PosterSerializer.new(poster)
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.new(poster)
    end

    def update 
        poster = Poster.update!(params[:id], poster_params)
        render json: PosterSerializer.new(poster)
    end

    def delete
        poster = Poster.find(params[:id])
        poster.destroy
        head :no_content
    end

    def search_by_name
        name = params[:name]
        posters = Poster.search_by_name(name)
        render json: PosterSerializer.format_posters(posters)
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end

end