class Api::V1::PostersController < ApplicationController
    










    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.format_poster(poster)
    end

end