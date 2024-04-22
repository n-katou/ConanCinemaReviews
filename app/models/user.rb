class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reviews, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  before_save :set_default_avatar, if: -> { avatar.blank? } 

  private

  def set_default_avatar
    default_avatar_path = Rails.root.join('public/images/fallback/sample.jpg')  # 正しいパスでデフォルトを参照
    self.avatar = File.open(default_avatar_path) if File.exist?(default_avatar_path)  # ファイルが存在する場合に設定
  end
end
