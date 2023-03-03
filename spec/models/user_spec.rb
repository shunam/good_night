require 'rails_helper'

RSpec.describe User, type: :model do
  it 'can not be save without name' do
    user = User.new
    expect(user.save).to be false
    expect(user.errors.full_messages).to include("Name can't be blank")
  end
end
