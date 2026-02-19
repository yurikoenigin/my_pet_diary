class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: %i[ show edit update destroy ]

  def index
    @pets = current_user.pets
  end

  def show; end

  def new
    @pet = current_user.pets.build
  end

  def edit; end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to pets_path, notice: "ペットを登録しました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pet.update(pet_params)
      redirect_to pets_path, notice: "ペット情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_path, notice: "ペットを削除しました。"
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pets_path, alert: "アクセス権限がありません。"
  end

  def pet_params
    params.require(:pet).permit(:name, :birthday, :adopted_at, :gender, :active, :image)
  end
end
