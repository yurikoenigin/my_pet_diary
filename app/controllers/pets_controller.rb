class PetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet, only: %i[ show edit update destroy ]

  def index
    @pets = current_user.pets.order(active: :desc, birthday: :asc)
  end

  def show; end

  def new
    @pet = current_user.pets.build
  end

  def edit; end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to pets_path, notice: t("defaults.flash_message.created", item: Pet.model_name.human)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pet.update(pet_params)
      redirect_to pets_path, notice: t("defaults.flash_message.updated", item: Pet.model_name.human)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy!
    redirect_to pets_path, notice: t("defaults.flash_message.deleted", item: Pet.model_name.human)
  end

  private

  def set_pet
    @pet = current_user.pets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pets_path, alert: t("defaults.flash_message.no_permission")
  end

  def pet_params
    params.require(:pet).permit(:name, :birthday, :adopted_at, :gender, :active, :image, :remove_image)
  end
end
