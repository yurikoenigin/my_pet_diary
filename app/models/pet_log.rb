class PetLog < ApplicationRecord
  belongs_to :user
  belongs_to :pet
  belongs_to :log_type, optional: true

  validate :log_type_or_weight_present

  def log_type_or_weight_present
    if log_type_id.blank? && weight.blank?
      errors.add(:base, "ログの種類、または体重のどちらか一方は入力してください")
    end
  end
end
