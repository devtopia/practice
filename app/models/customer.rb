class Customer < ActiveRecord::Base
  validates :family_name, presence: true, length: {maximum: 40}
  validates :given_name, presence: true, length: {maximum: 40}
  validates :family_name_kana, presence: true, length: {maximum: 40}
  validates :given_name_kana, presence: true, length: {maximum: 40}
end
