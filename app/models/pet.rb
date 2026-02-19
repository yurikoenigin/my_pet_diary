class Pet < ApplicationRecord
  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  belongs_to :user

  has_one_attached :image

  # ファイルの種類とサイズのバリデーション（gem ActiveStorage Validationを使用）
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif].freeze
  validates :image, content_type: ACCEPTED_CONTENT_TYPES, size: { less_than_or_equal_to: 5.megabytes }

  enum :gender, { male: 0, female: 1, other: 2 }

  def age
    return nil if birthday.blank?

    # 今日の日付と誕生日の差から年齢を計算
    d1 = birthday.strftime("%Y%m%d").to_i
    d2 = Time.zone.now.strftime("%Y%m%d").to_i
    (d2 - d1) / 10000
  end
end
