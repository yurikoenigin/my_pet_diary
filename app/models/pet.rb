class Pet < ApplicationRecord
  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  belongs_to :user

  has_one_attached :image

  # ファイルの種類とサイズのバリデーション（gem ActiveStorage Validationを使用）
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif].freeze
  validates :image, content_type: ACCEPTED_CONTENT_TYPES, size: { less_than_or_equal_to: 5.megabytes }

  attr_accessor :remove_image

  before_save :purge_image, if: -> { remove_image == "1" }

  enum :gender, { male: 0, female: 1, other: 2 }

  def age
    return nil if birthday.blank?
    # 今日の日付と誕生日の差から年齢を計算
    d1 = birthday.strftime("%Y%m%d").to_i
    d2 = Time.zone.now.strftime("%Y%m%d").to_i
    res = (d2 - d1) / 10000
    "#{res}歳"
  end

  private

  def purge_image
    image.purge
  end
end
