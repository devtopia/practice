require 'rails_helper'

describe RewardService, '#grant_login_points' do
  let(:customer) { create(:customer) }
  let(:date_boundary) { Time.zone.local(2015, 12, 14, 5, 0, 0) }

  before { Time.zone = 'Tokyo' }

  example '土曜日の午前5時直前にログインすると、ユーザーの保有ポイントが1増える' do
    Timecop.freeze(Time.zone.local(2015, 12, 12, 4, 59, 59))
    expect {
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(1)
  end

  example '土曜日の午前5時にログインすると、ユーザーの保有ポイントが3増える' do
    Timecop.freeze(Time.zone.local(2015, 12, 12, 5, 0, 0))
    expect {
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(3)
  end

  example '日曜日の午前5時直前にログインすると、ユーザーの保有ポイントが3増える' do
    Timecop.freeze(Time.zone.local(2015, 12, 13, 4, 59, 59))
    expect {
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(3)
  end

  example '日曜日の午前5時にログインすると、ユーザーの保有ポイントが1増える' do
    Timecop.freeze(Time.zone.local(2015, 12, 13, 5, 0, 0))
    expect {
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(1)
  end

  example '日付変更時刻をまたいで２回ログインすると、ユーザーの保有ポイントが２増える' do
    Time.zone = 'Tokyo'
    expect {
      Timecop.freeze(date_boundary.advance(seconds: -1))
      RewardService.new(customer).grant_login_points
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(2)
  end

  example '日付変更時刻をまたがずに２回ログインしても、ユーザーの保有ポイントは１しか増えない' do
    Time.zone = 'Tokyo'
    expect {
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
      Timecop.freeze(date_boundary)
      RewardService.new(customer).grant_login_points
    }.to change { customer.points }.by(1)
  end

end
