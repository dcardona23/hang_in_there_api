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
        if Poster.exists?(name: poster_params[:name])
            render json: {
                "errors": [
                    {
                        status: "422",
                        message: "Duplicate name entered."
                    }
                ]
            }, status: :unprocessable_entity
        else
            poster = Poster.create!(poster_params)
            render json: PosterSerializer.new(poster), status: :created
        end
    end

    def show
        begin
            poster = Poster.find(params[:id])
            render json: PosterSerializer.new(poster)
        rescue ActiveRecord::RecordNotFound
            render json: { 
                errors: [
                    {
                        status: "404",
                        message: "Record not found"
                    }
                ]
            }, status: :not_found
        end
    end

    def update 
        poster = Poster.find(params[:id])

        if Poster.exists?(name: poster_params[:name]) && poster.name != poster_params[:name]
            render json: {
                "errors": [
                    {
                        status: "422",
                        message: "Duplicate name entered."
                    }
                ]
            }, status: :unprocessable_entity
        else    
            if poster.update!(poster_params)
            render json: PosterSerializer.new(poster), status: :ok
            end
        end
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