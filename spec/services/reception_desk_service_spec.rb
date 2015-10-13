require 'rails_helper'

describe ReceptionDeskService, '#sign_in' do
  let(:customer) {create(:customer, username: 'taro', password: BCrypt::Password.create('correct_password'))}

  example 'ユーザー名とパスワードに該当するCustomerオブジェクトを返す' do
    result = ReceptionDeskService.new(customer.username, 'correct_password').sign_in
    expect(result).to eq(customer)
  end

  example 'パスワードが一致しない場合nilを返す' do
    result = ReceptionDeskService.new(customer.username, 'wrong_password').sign_in
    expect(result).to be_nil
  end

  example '該当するユーザー名が存在しない場合はnilを返す' do
    result = ReceptionDeskService.new('hanako', 'any_string').sign_in
    expect(result).to be_nil
  end

  example 'パスワード未設定のユーザーを拒絶する' do
    customer.update_column(:password_digest, nil)
    result = ReceptionDeskService.new(customer.username, '').sign_in
    expect(result).to be_nil
  end

  example 'ログインに成功すると、ユーザーの保有ポイントが１増える' do
    # pending 'Customer#pointsが未実装'
    # allow(customer).to receive(:points).and_return(0)
    expect {
      ReceptionDeskService.new(customer.username, 'correct_password').sign_in
    }.to change { customer.points }.by(1)
  end
end
