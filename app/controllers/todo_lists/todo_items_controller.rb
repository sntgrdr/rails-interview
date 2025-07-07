module TodoLists
  class TodoItemsController < ApplicationController
    before_action :instance_todo_list
    before_action :instance_todo_item, only: %i[show edit update destroy]

    def index
      @todo_items = @todo_list.todo_items
    end

    def new
      @todo_item = TodoItem.new
    end

    def create
      @todo_item = @todo_list.todo_items.build(todo_item_params)

      if @todo_item.save
        redirect_to @todo_list
      else
        redirect_to new_todo_list_todo_item_path(@todo_list), alert: @todo_item.errors.full_messages
      end
    end

    def show; end

    def edit; end

    def update
      if @todo_item.update(todo_item_params)
        redirect_to @todo_item
      else
        redirect_to :edit, flash[:alert] = @todo_item.errors.full_messages
      end
    end

    def destroy
      @todo_item.destroy
      redirect_to :index, flash[:notice] = 'Sucessfully deleted'
     end

    private

    def instance_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def instance_todo_item
      @todo_item = @todo_list.todo_items.find(params[:id])
    end

    def todo_item_params
      params.require(:todo_item).permit(:name, :description, :completed)
    end
  end
end