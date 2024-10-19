module Clients
  class UsersController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to clients_root_path, notice: 'Account created successfully.'
      else
        render :new
      end
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(user_params)
        redirect_to clients_root_path, notice: 'Profile updated successfully.'
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
