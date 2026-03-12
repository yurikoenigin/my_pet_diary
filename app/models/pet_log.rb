class PetLog < ApplicationRecord
  belongs_to :user
  belongs_to :pet
  belongs_to :log_type, optional: true

  validates :weight, numericality: { greater_than: 0, allow_nil: true }
  validate :log_type_or_weight_present

  # フォームから送られてくる一時的なデータを受け取る窓口
  attr_accessor :occurred_date, :occurred_time

  # 保存の直前に、2つの値を合体させて occurred_at に代入する
  before_validation :merge_occurred_date_and_time

  def log_type_or_weight_present
    if log_type_id.blank? && weight.blank?
      errors.add(:base, "ログの種類、または体重のどちらか一方は入力してください")
    end
  end

  private

  def merge_occurred_date_and_time
    if occurred_date.present?
      # 時刻が空なら "00:00" として扱う
      time_part = occurred_time.presence || "00:00"
      # Time.zone.parse で現在のタイムゾーンに合わせた日時オブジェクトを作成
      self.occurred_at = Time.zone.parse("#{occurred_date} #{time_part}")
    end
  rescue ArgumentError
    # 万が一、不正な文字列が送られてきた場合の処理
    nil
  end
end
