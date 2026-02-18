class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: %i[ show ]

  def index
    @pets = current_user.pets
  end

  def show; end

  private

  def set_pet
    @pet = current_user.pets.find(params[id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pets_path, alert: "アクセス権限がありません。"
  end

  def pet_params
    params.require(:pet).permit(:name, :birthday, :adopted_at, :gender, :active)
  end
end
