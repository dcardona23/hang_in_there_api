class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end










    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.format_poster(poster)
    end

    def update 
        poster = Poster.update(params[:id], poster_params)
        render json: PosterSerializer.format_poster(poster)
    end

    private

    def poster_params
        params.require(:poster).permit(:id, :name, :description, :price, :year, :vintage, :img_url)
    end

end