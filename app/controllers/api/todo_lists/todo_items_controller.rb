module Api
  module TodoLists
    class TodoItemsController < ApplicationController
      before_action :instance_todo_list
      before_action :instance_todo_item, only: %i[show edit update destroy]

      def index
        @todo_items = @todo_list.todo_items

        respond_to :json
      end

      def new
        @todo_item = TodoItem.new
        respond_to :json
      end

      def create
        @todo_item = @todo_list.todo_items.build(todo_item_params)

        if @todo_item.save
          render :show, status: :ok
        else
          render json: { errors: @todo_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        respond_to :json
      end

      def edit; end

      def update
        if @todo_item.update(todo_item_params)
          render :show
        else
          render json: { errors: @todo_item.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @todo_item.destroy
        head :ok
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
end
