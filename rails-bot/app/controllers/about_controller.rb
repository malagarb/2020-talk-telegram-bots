class AboutController < ApplicationController
  def index
    render json: {bot: "rubybot"}
  end
end
