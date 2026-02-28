class PetLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet_log, only: %i[ show edit update destroy ]

  def index
    @pet_logs = current_user.pet_logs
                            .includes(:log_type, pet: { image_attachment: :blob })
                            .order(occurred_at: :desc)
  end

  def show; end

  def new
    @pet_log = current_user.pet_logs.build
  end

  def edit; end

  def create
    @pet_log = current_user.pet_logs.build(pet_log_params)
    if @pet_log.save
      redirect_to pet_logs_path, notice: t("defaults.flash_message.created", item: PetLog.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pet_log.update(pet_log_params)
      redirect_to pet_logs_path, notice: t("defaults.flash_message.updated", item: PetLog.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet_log.destroy!
    redirect_to pet_logs_path, notice: t("defaults.flash_message.deleted", item: PetLog.model_name.human)
  end

  private

  def set_pet_log
    @pet_log = current_user.pet_logs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to pet_logs_path, alert: t("defaults.flash_message.no_permission")
  end

  def pet_log_params
    params.require(:pet_log).permit(
      :content, :weight, :pet_id, :log_type_id,
      :occurred_date, :occurred_time # occurred_at の代わりにこの2つを許可
    )
  end
end
