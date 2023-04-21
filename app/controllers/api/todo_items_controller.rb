module Api
  class TodoItemsController < ApplicationController
    before_action :todo_list, only: :index

    def index
      @todo_items = todo_list.todo_items

      respond_to :json
    end

    def create
      @todo_item = todo_list.todo_items.build(todo_items_params)

      return render :show if @todo_item.save!

      render json: { errors: @todo_item.errors }, status: :unprocessable_entity
    end

    private

    def todo_list
      @todo_list = TodoList.find_by!(id: params[:todo_list_id])
    end

    def todo_items_params
      params.require(:todo_item).permit(:title, :description)
    end
  end
end
