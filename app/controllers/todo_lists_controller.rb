class TodoListsController < ApplicationController
  before_action :instance_todo_list, only: %i[show mark_all_as_completed]
  # GET /todolists
  def index
    @todo_lists = TodoList.all

    respond_to :html
  end

  # GET /todolists/new
  def new
    @todo_list = TodoList.new

    respond_to :html
  end

  def show; end

  def create
    @todo_list = TodoList.new(todo_list_params)

    if @todo_list.save
      redirect_to @todo_list
    else
      flash[:alert] = @todo_list.errors.full_messages
      redirect_to new_todo_list_path
    end
  end

  def mark_all_as_completed
    todo_items = @todo_list.todo_items
    MarkAllAsCompletedJob.perform_later(todo_item_ids: todo_items.pluck(:id))
    redirect_to @todo_list
  end

  private

  def todo_list_params
    params.require(:todo_list).permit(:name)
  end

  def instance_todo_list
    @todo_list = TodoList.find(params[:id])
  end
end
