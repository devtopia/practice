require 'rails_helper'

describe RewardService, '#grant_login_points' do
  let(:customer) { create(:customer) }

  example '日付変更時刻をまたいで２回ログインすると、ユーザーの保有ポイントが２増える' do
    Time.zone = 'Tokyo'
    date_boundary = Time.zone.local(2015, 9, 27, 5, 0, 0)
    expect {
      Timecop.freeze(date_boundary.advance(seconds: -1))
      RewardService.new(customer).grant_login_points
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(2)
  end

  example '日付変更時刻をまたがずに２回ログインしても、ユーザーの保有ポイントは１しか増えない' do
    Time.zone = 'Tokyo'
    date_boundary = Time.zone.local(2015, 9, 27, 5, 0, 0)
    expect {
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(1)
  end

end
