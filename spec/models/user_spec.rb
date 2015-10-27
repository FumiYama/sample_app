require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(name: "Example User",
                     email: "user@example.com",
                    password: "foobar",
                    password_confirmation: "foobar")
  end

  subject { @user } #@userがテストの主題(subject)であることをRSpecに伝えることで、冗長の原因を排除できる

  it { should respond_to(:name) }
# it "should respond to 'name'" do
  # except(@user) respond_to(:name)
# end とも書けるが、subject{@user}があるので省略して書いてる
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }


  it { should be_valid }

  describe "when name is not present" do # 名前があるかどうかの検証
    before { @user.name = " "}
    it { should_not be_valid }
  end

  describe "when email is not present" do #emailがあるかどうか
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do #名前を50文字以下に
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do #メールフォ−マットでダメな奴
    it "should be invalid" do
      adresses = %w[user@@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      adresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do #メールフォーマットで大丈夫な奴
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email adress is already taken" do #重複メールアドレスの拒否テスト
    before do #事前に同じメールアドレスのユーザを作成する
      user_with_same_email = @user.dup #同じ属性にするためにdupを使用. dupはレシーバのオブジェクトのコピーを作成して返す
      user_with_same_email.email = @user.email.upcase # upcaseメソッド==文字列を大文字に
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMple.COM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end




  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User",
                       email: "user@example.com",
                       password: " ",
                       password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end


describe "return value of authenticate method" do
  before { @user.save }
  let(:found_user) {User.find_by(email: @user.email) }# let値をメモ化

  describe "with valid password" do #パスワードが一致する場合
    it { should eq found_user.authenticate(@user.password) }
  end #eqはオブジェクト同士が同値かどうか

  describe "with invalid password" do#一致しない場合
    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    it { should_not eq user_for_invalid_password }
    specify { expect(user_for_invalid_password).to be_falsey } # be_falseyはバージョンによる違い？ Tutorialはbe_false
  end
end

describe "with a password that's too short" do #パスワード短すぎないか
  before { @user.password = @user.password_confirmation = "a" * 5 }
  it { should be_invalid }
end







end
