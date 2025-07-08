require 'rails_helper'

describe Api::TodoListsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json

        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'GET mark_all_as_completed' do
    let!(:todo_list) { TodoList.create!(name: 'Test list') }
    let!(:todo_item1) { todo_list.todo_items.create!(name: 'Item 1', completed: false) }
    let!(:todo_item2) { todo_list.todo_items.create!(name: 'Item 2', completed: false) }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :mark_all_as_completed, params: { id: todo_list.id }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      before do
        ActiveJob::Base.queue_adapter = :test
      end

      it 'returns accepted status and enqueues job' do
        expect {
          get :mark_all_as_completed, params: { id: todo_list.id }, format: :json
        }.to have_enqueued_job(MarkAllAsCompletedJob)

        expect(response.status).to eq(202)

        json = JSON.parse(response.body)
        expect(json['message']).to include('Enqueued job')
        expect(json['todo_list_id']).to eq(todo_list.id)
      end
    end
  end

  describe 'GET #progress' do
    let!(:todo_list) { TodoList.create!(name: 'Test List') }
    let!(:completed_item) { todo_list.todo_items.create!(name: 'Completed', completed: true) }
    let!(:uncompleted_item) { todo_list.todo_items.create!(name: 'Pending') }

    context 'when format is JSON' do
      it 'returns the correct progress counts' do
        get :progress, params: { id: todo_list.id }, format: :json

        expect(response.status).to eq(200)
        json = JSON.parse(response.body)

        expect(json['completed']).to eq(1)
        expect(json['total']).to eq(2)
      end
    end

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :progress, params: { id: todo_list.id }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end
  end
end
