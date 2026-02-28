class LogType < ApplicationRecord
  validates :name, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  belongs_to :user

  has_many :pet_logs, dependent: :destroy
end
