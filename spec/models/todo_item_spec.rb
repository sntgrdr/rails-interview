require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  describe '#validations' do
    it 'is invalid without a name' do
      todo_item = TodoItem.new(name: nil)
      expect(todo_item).not_to be_valid
      expect(todo_item.errors[:name]).to include("can't be blank")
    end
  end
  describe '#associations' do
    it 'is invalid without a todo_list' do
      todo_item = TodoItem.new(name: 'Install Rspec gem', todo_list: nil)
      expect(todo_item).not_to be_valid
      expect(todo_item.errors[:todo_list]).to include('must exist')
    end
  end
end
