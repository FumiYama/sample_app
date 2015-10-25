module ApplicationHelper
  # ページごとの完全なタイトルを返します
  def full_title(page_title) # メソッド定義
    base_title = "Ruby on Rails Tutorial Sample App" #変数に値を割り当てる
    if page_title.empty? #理論値テスト
      base_title #暗黙の返り値(戻り値)
    else
      "#{base_title} | #{page_title}" #文字列の式展開
    end
  end
end


# require 'rails_helper'

# describe ApplicationHelper do

#   describe "full_title" do
#     it "should include the page title" do
#       expect(full_title("foo")).to match(/foo/)
#     end

#     it "should include the base title" do
#       expect(full_title("foo")).to match(/^Ruby on Rails Tutorial Sample App/)
#     end

#     it "should not include a bar for the home page" do
#       expect(full_title("")).not_to match(/\|/)
#     end
#   end
# end