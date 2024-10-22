class Api::V1::PostersController < ApplicationController
    










    def show
        render json: Poster.find(params[:id])
    end

end