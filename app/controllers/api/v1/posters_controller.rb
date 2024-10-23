class Api::V1::PostersController < ApplicationController
    def index
        #binding.pry
        if params[:sort] == "asc"
            posters = Poster.all.order(:created_at)
        elsif params[:sort] == "desc"
            posters = Poster.all.order("created_at desc")
        else
            posters = Poster.all
        end
        
        #params[:sort] will be "asc" or "des"

        render json: PosterSerializer.new(posters, meta: {
            count: posters.count
        })
    end

    def create
        poster = Poster.create(poster_params)
        render json: PosterSerializer.format_poster(poster)
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.format_poster(poster)
    end

    def update 
        poster = Poster.update(params[:id], poster_params)
        render json: PosterSerializer.format_poster(poster)
    end

    def delete
        poster = Poster.find(params[:id])
        poster.destroy
        head :no_content
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end

end