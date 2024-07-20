class WelcomeController < ApplicationController
  def index
    render plain: 'Welcome to the Blog API'
  end
end
