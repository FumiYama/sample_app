module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token #トークンの新規作成
    cookies.permanent[:remember_token] = remember_token #暗号化されていないt−くんをブラウザのcookiesに保存
    user.update_attribute(:remember_token, User.encrypt(remember_token)) # 暗号化したトークンをDBに保存
    self.current_user = user # 与えられたuserを現在のuserに設定
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user) # self.current_user = user に置き換えられる
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end


  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
