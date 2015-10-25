class User < ActiveRecord::Base
  before_save { self.email = email.downcase } #Stringクラスのdoencaseメソッドで全部小文字に
  validates(:name, presence: true,
                   length: {maximum: 50})
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # 正規表現VALID~は定数(大文字から始める)
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
end
