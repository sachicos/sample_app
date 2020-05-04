class User < ApplicationRecord
  attr_accessor :remember_token # 仮想的な属性を作る。メソッドを作るメソッド。
  before_save { self.email = self.email.downcase }
  validates :name,  presence: true, 
                      length: { maximum: 50 }
                      
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                      length: {maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
                      
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
    # config/min-cost = true:テスト用のサボるパスワード生成。本番はガチの設定で。
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64 #平文のパスワードを作る
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil? # remember_digestがnilだったら、falseを返してその後の処理を実行しない
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    self.update_attribute(:remember_digest, nil)#bcriptの機構で、nilはありえないから、必ず失敗する
  end
end
