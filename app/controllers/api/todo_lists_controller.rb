module Api
  class TodoListsController < ApplicationController
    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    def mark_all_as_completed
      todo_list = TodoList.find(params[:id])
      todo_items = todo_list.todo_items.uncompleted

      MarkAllAsCompletedJob.perform_later(todo_item_ids: todo_items.pluck(:id))

      respond_to do |format|
        format.json { render json: { message: "Job encolado para completar #{todo_items.count} items.", todo_list_id: todo_list.id }, status: :accepted }
      end
    end

    def progress
      todo_list = TodoList.find(params[:id])
      completed = todo_list.todo_items.completed.count
      total = todo_list.todo_items.count

      respond_to do |format|
        format.json { render json: { completed: completed, total: total } }
      end
    end
  end
end
