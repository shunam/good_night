require 'rails_helper'

RSpec.describe User, type: :model do
  it 'can not be save without name' do
    user = User.new
    expect(user.save).to be false
    expect(user.errors.full_messages).to include("Name can't be blank")
  end

  context 'with user Hendrik' do
    before(:each) do
      @user = User.create(name: 'Hendrik')
    end

    it 'has one friend' do
      friend = User.create(name: 'Friend 1')
      friend.save
      @user.friends << friend
      @user.reload
      expect(@user.friends[0].name).to eq(friend.name)
    end
  end
end
