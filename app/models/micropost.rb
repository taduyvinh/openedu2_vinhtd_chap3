class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  mount_uploader :picture, PictureUploader

  scope :ordered, ->{order created_at: :desc}

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("picture_size_error")
    end
  end
end
