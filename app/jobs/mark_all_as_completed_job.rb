class MarkAllAsCompletedJob < ApplicationJob
  queue_as :default

  def perform(todo_item_ids:)
    todo_items = TodoItem.where(id: todo_item_ids)
    total = todo_items.count

    todo_items.find_each(batch_size: 500) do |todo_item|
      todo_item.update!(completed: true)

      completed = TodoItem.where(id: todo_item_ids, completed: true).count

      Turbo::StreamsChannel.broadcast_replace_to(
        "todo_list_#{todo_item.todo_list_id}_items",
        target: ActionView::RecordIdentifier.dom_id(todo_item),
        partial: 'todo_lists/item',
        locals: { todo_item: todo_item }
      )

      Turbo::StreamsChannel.broadcast_replace_to(
        "todo_list_#{todo_item.todo_list_id}_progress",
        target: 'todo_progress',
        partial: 'todo_lists/progress',
        locals: { completed: completed, total: total }
      )
      sleep 10 # Sleep added to simulate production server latency
    end
  end
end
