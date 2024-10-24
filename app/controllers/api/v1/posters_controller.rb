class Api::V1::PostersController < ApplicationController
    def index
        if params[:sort] == "asc"
            posters = Poster.all.order(:created_at)
        elsif params[:sort] == "desc"
            posters = Poster.all.order("created_at desc")
        else
            posters = Poster.all
        end

        if params[:name]
            posters = Poster.search_by_name(params[:name])
        end

        if params[:max_price]
            posters = Poster.search_by_max_price(params[:max_price])
        end

        if params[:min_price]
            posters = Poster.search_by_min_price(params[:min_price])
        end

        render json: PosterSerializer.new(posters, meta: {
        count: posters.count
        })
    end

    def create
        poster = Poster.create(poster_params)
        #render json: PosterSerializer.format_poster(poster)
        render json: PosterSerializer.new(poster)
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.format_poster(poster)
        #render json: PosterSerializer.new(poster)
    end

    def update 
        poster = Poster.update(params[:id], poster_params)
        render json: PosterSerializer.format_poster(poster)
        #render json: PosterSerializer.new(poster)
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