class LogTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_log_type, only: %i[ show edit update destroy ]

  def index
    @log_types = current_user.log_types.order(active: :desc, id: :asc)
  end

  def show; end

  def new
    @log_type = current_user.log_types.build
  end

  def edit; end

  def create
    @log_type = current_user.log_types.build(log_type_params)
    if @log_type.save
      redirect_to log_types_path, notice: t("defaults.flash_message.created", item: LogType.model_name.human)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @log_type.update(log_type_params)
      redirect_to log_types_path, notice: t("defaults.flash_message.updated", item: LogType.model_name.human)
    else
      flash.now[:alert] = "入力内容に不備があります"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @log_type.destroy!
    redirect_to log_types_path, notice: t("defaults.flash_message.deleted", item: LogType.model_name.human)
  end

  private

  def set_log_type
    @log_type = current_user.log_types.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to log_types_path, alert: t("defaults.flash_message.no_permission")
  end

  def log_type_params
    params.require(:log_type).permit(:name, :description, :active)
  end
end
