class PetLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pet_log, only: %i[ show edit update destroy ]
  before_action :check_pet_exists, only: [ :new, :create ]

  def index
    @pet_logs = current_user.pet_logs
                            .includes(:log_type, pet: { image_attachment: :blob })
                            .order(occurred_at: :desc)
    @pets = current_user.pets.order(:created_at)
    @log_types = current_user.log_types

    if params[:pet_id].present?
      @pet_logs = @pet_logs.where(pet_id: params[:pet_id])
    end

    @pet_logs = @pet_logs.where(pet_id: params[:pet_id]) if params[:pet_id].present?
    @pet_logs = @pet_logs.where(log_type_id: params[:log_type_id]) if params[:log_type_id].present?

    if params[:from_month].present? || params[:to_month].present?
      start_date = params[:from_month].present? ? Time.zone.parse("#{params[:from_month]}-01").beginning_of_month : Time.at(0)
      end_date = params[:to_month].present? ? Time.zone.parse("#{params[:to_month]}-01").end_of_month : Time.zone.now.end_of_year + 100.years
      @pet_logs = @pet_logs.where(occurred_at: start_date..end_date)
    end

    if params[:has_weight] == "1"
      @pet_logs = @pet_logs.where.not(weight: nil)
    end

    @pet_logs = @pet_logs.page(params[:page]).per(10)
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
      flash.now[:alert] = "入力内容に不備があります"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pet_log.update(pet_log_params)
      redirect_to pet_logs_path, notice: t("defaults.flash_message.updated", item: PetLog.model_name.human)
    else
      flash.now[:alert] = "入力内容に不備があります"
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

  def check_pet_exists
    # 「activeがtrue」のペットが1匹も存在しない場合
    unless current_user.pets.exists?(active: true)
      redirect_to pets_path, alert: "まずはペットを登録（または有効化）してください。"
    end
  end
end
