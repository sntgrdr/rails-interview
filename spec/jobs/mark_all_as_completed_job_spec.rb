require 'rails_helper'

RSpec.describe MarkAllAsCompletedJob, type: :job do
  let!(:todo_list) { TodoList.create!(name: "Test list") }
  let!(:todo_item1) { todo_list.todo_items.create!(name: "Item 1", completed: false) }
  let!(:todo_item2) { todo_list.todo_items.create!(name: "Item 2", completed: false) }

  describe '#perform' do
    it 'marks all todo_items as completed and broadcasts updates' do
      todo_item_ids = todo_list.todo_items.uncompleted.pluck(:id)
      total = todo_item_ids.size

      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).at_least(:once).and_call_original

      MarkAllAsCompletedJob.perform_now(todo_item_ids: todo_item_ids)

      todo_list.todo_items.each do |item|
        expect(item.reload.completed).to be true
      end
    end
  end
end
