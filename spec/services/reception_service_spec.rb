require 'rails_helper'

describe ReceptionService, '#sign_in' do
  let(:customer) {create(:customer, username: 'taro', password: BCrypt::Password.create('correct_password'))}

  context 'ユーザー名とパスワードが一致する場合' do
    example '該当するCustomerオブジェクトを返す' do
      result = ReceptionService.new(customer.username, 'correct_password').sign_in
      expect(result).to eq(customer)
    end

    example 'RewardService#grant_login_pointsが呼ばれる' do
      expect_any_instance_of(RewardService).to receive(:grant_login_points)
      ReceptionService.new(customer.username, 'correct_password').sign_in
    end
  end

  context '該当するユーザー名が存在しない場合' do
    example 'nilを返す' do
      result = ReceptionService.new('hanako', 'any_string').sign_in
      expect(result).to be_nil
    end

    example 'RewardService#grant_login_pointsが呼ばれない' do
      expect_any_instance_of(RewardService).not_to receive(:grant_login_points)
      ReceptionService.new('hanako', 'any_string').sign_in
    end
  end

  context 'パスワードが一致しない場合' do
    example 'nilを返す' do
      result = ReceptionService.new(customer.username, 'wrong_password').sign_in
      expect(result).to be_nil
    end

    example 'RewardService#grant_login_pointsが呼ばれない' do
      expect_any_instance_of(RewardService).not_to receive(:grant_login_points)
      ReceptionService.new(customer.username, 'wrong_password').sign_in
    end
  end

  context 'パスワード未設定の場合' do
    before { customer.update_column(:password_digest, nil) }

    example 'nilを返す' do
      result = ReceptionService.new(customer.username, '').sign_in
      expect(result).to be_nil
    end

    example 'RewardService#grant_login_pointsが呼ばれない' do
      expect_any_instance_of(RewardService).not_to receive(:grant_login_points)
      ReceptionService.new(customer.username, 'wrong_password').sign_in
    end
  end

  example 'ログインに成功すると、ユーザーの保有ポイントが１増える' do
    # pending 'Customer#pointsが未実装'
    # allow(customer).to receive(:points).and_return(0)
    expect {
      ReceptionService.new(customer.username, 'correct_password').sign_in
    }.to change { customer.points }.by(1)
  end
end
