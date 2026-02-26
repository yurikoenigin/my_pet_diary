class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  has_many :pets, dependent: :destroy
  has_many :log_types, dependent: :destroy

  after_create :create_default_log_types

  private

  def create_default_log_types
    default_settings = [
      { name: '通院', description: '診察やワクチン接種など', active: true },
      { name: '投薬', description: 'ノミ薬やフィラリアの薬、その他の薬の投薬', active: true },
      { name: 'お出かけ', description: 'お出かけや旅行など', active: true },
      { name: '体調不良', description: '体調不良', active: true }
    ]
    default_settings.each do |setting|
      log_types.create!(setting)
    end
  end
end
