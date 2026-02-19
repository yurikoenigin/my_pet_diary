class Pet < ApplicationRecord
  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  belongs_to :user

  has_one_attached :image

  enum :gender, { male: 0, female: 1, other: 2 }
end
