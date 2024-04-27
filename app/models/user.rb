class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]
  has_many :reviews, dependent: :destroy
  mount_uploader :avatar, AvatarUploader
  has_many :likes, dependent: :destroy

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  # before_save :set_default_avatar, if: -> { avatar.blank? } 

  # private

  # def set_default_avatar
  #   default_avatar_path = Rails.root.join('public/images/fallback/sample.jpg')  # 正しいパスでデフォルトを参照
  #   self.avatar = File.open(default_avatar_path) if File.exist?(default_avatar_path)  # ファイルが存在する場合に設定
  # end
  def self.from_omniauth(auth)
    where(line_user_id: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.line_user_id = auth.uid  # LINEのユーザーID
    end
  end
end
