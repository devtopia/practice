require 'rails_helper'

describe 'トップページ' do
  example '挨拶文を表示' do
    visit root_path
    expect(page).to have_css('p', text: 'Hello World!')
  end
end
