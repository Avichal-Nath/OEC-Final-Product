class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:index, :show] # Adjust based on routes you want public
end
