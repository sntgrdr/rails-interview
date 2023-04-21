require 'rails_helper'

RSpec.describe 'POST /api/todolists/:todo_list_id/todo_items', type: :request do
  subject(:post_request) do
    post api_todo_list_todo_items_path(todo_list_id), params: { todo_item: params }, as: :json
  end
  
  let(:params) { { title: 'Spec title', description: 'This is a description' } }
  let(:todo_list_id) { TodoList.create!(name: 'Test') }

  context 'when the request is valid' do
    it 'returns status code 200' do
      post_request
      expect(response).to have_http_status(:ok)
    end

    it 'creates a new todo_item' do
      expect { post_request }.to change(TodoItem, :count).from(0).to(1)
    end
  end
end
