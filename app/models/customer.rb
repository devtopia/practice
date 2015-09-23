require 'nkf'
require 'bcrypt'

class Customer < ActiveRecord::Base
  attr_accessor :password

  validates :family_name, presence: true, length: {maximum: 40},
            format: {with: /\A[\p{Han}\p{Hiragana}\p{Katakana}\u30fc]+\z/, allow_blank: true}
  validates :given_name, presence: true, length: {maximum: 40},
            format: {with: /\A[\p{Han}\p{Hiragana}\p{Katakana}\u30fc]+\z/, allow_blank: true}
  validates :family_name_kana, presence: true, length: {maximum: 40},
            format: {with: /\A\p{Katakana}+\z/, allow_blank: true}
  validates :given_name_kana, presence: true, length: {maximum: 40},
            format: {with: /\A\p{Katakana}+\z/, allow_blank: true}

  before_validation do
    self.family_name = NKF.nkf('-w', family_name) if family_name
    self.given_name = NKF.nkf('-w', given_name) if given_name
    self.family_name_kana = NKF.nkf('-wh2', family_name_kana) if family_name_kana
    self.given_name_kana = NKF.nkf('-wh2', given_name_kana) if given_name_kana
  end

  before_save do
    self.password_digest = password if password.present?
  end

  def self.authenticate(username, password)
    customer = find_by_username(username)
    if customer && BCrypt::Password.new(customer.password_digest) == customer.password
      customer
    else
      nil
    end
  end
end
