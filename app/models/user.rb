class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]
  has_many :reviews, dependent: :destroy
  mount_uploader :avatar, AvatarUploader
  has_many :likes, dependent: :destroy

  # before_save :set_default_avatar, if: -> { avatar.blank? } 

  # private

  # def set_default_avatar
  #   default_avatar_path = Rails.root.join('public/images/fallback/sample.jpg')  # 正しいパスでデフォルトを参照
  #   self.avatar = File.open(default_avatar_path) if File.exist?(default_avatar_path)  # ファイルが存在する場合に設定
  # end
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
    # self.set_values_by_raw_info(omniauth['extra']['raw_info'])
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end
end
