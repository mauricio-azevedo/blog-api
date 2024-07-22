class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    render plain: 'Welcome to the Blog API'
  end
end
