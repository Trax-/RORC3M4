module Api
  class RacesController < ApplicationController

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      @msg = "woops: cannot find race[#{params[:id]}]"

      if !request.accept || request.accept == '*/*'
        render plain: @msg, status: :not_found
      else
        render status: :not_found, :template => 'api/error_msg'
      end
    end

    rescue_from ActionView::MissingTemplate do |exception|
      Rails.logger.debug("Accept:#{request.accept}")
      render plain: "woops: we do not support that content-type[#{request.accept}]", status: :unsupported_media_type
    end

    def index
      if !request.accept || request.accept == '*/*'
        render plain: "#{api_races_path}, offset=[#{params[:offset]}], limit=[#{params[:limit]}]"
      end
    end

    def show
      if !request.accept || request.accept == '*/*'
        render plain: api_race_path(params[:id])
      else
        set_race
        render 'race', status: :ok
      end
    end

    def create
      if !request.accept || request.accept == '*/*'
        #render plain: :nothing, status: :ok
        render plain: params[:race][:name]
      else
        @race = Race.new(race_params)

        if @race.save
          render plain: race_params[:name], status: :created
        else
          render json: @race.errors
        end
      end
    end

    def update
      Rails.logger.debug("method=#{request.method}")
      set_race

      if @race.update(race_params)
        render json: @race
      else
        render json: @race.errors
      end
    end

    def destroy
      set_race
      if @race.destroy
        render nothing: true, status: :no_content
      else
        render nothing: true, status: :error
      end
    end

    private
    def set_race
      @race = Race.find(params[:id])
    end

    def race_params
      params.require(:race).permit(:name, :date)
    end

  end

end
