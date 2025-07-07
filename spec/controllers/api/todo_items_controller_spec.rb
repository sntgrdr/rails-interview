require 'rails_helper'

describe Api::TodoLists::TodoItemsController, type: :controller do
  let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }
  let(:todo_list_id) { todo_list.id }
  let!(:todo_item_rspec) { TodoItem.create(name: 'Install Rspec gem', todo_list_id:) }
  let!(:todo_item_rubocop) { TodoItem.create(name: 'Install Rubocop gem', todo_list_id:) }
  render_views

  describe 'GET #index' do
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index, params: { todo_list_id: todo_list_id }
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, params: { todo_list_id: todo_list_id }, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, params: { todo_list_id: todo_list_id }, format: :json

        todo_items = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_items.count).to eq(2)
          expect(todo_items[0].keys).to match_array(['id', 'name', 'completed', 'todo_list_id'])
          expect(todo_items[0]['id']).to eq(todo_items.first['id'])
          expect(todo_items[0]['name']).to eq(todo_items.first['name'])
        end
      end
    end
  end

  describe 'GET #new' do
    context 'when format is HTML' do
      it 'raises routing error' do
        expect {
          get :new, params: { todo_list_id: todo_list_id }, format: :html
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a new todo item' do
        get :new, params: { todo_list_id: todo_list_id }, format: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'when format is JSON' do
      it 'returns the todo item' do
        get :show, params: { todo_list_id: todo_list_id, id: todo_item_rspec.id }, format: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(todo_item_rspec.id)
        expect(json['name']).to eq(todo_item_rspec.name)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { { todo_item: { name: 'Install Rspec gem', completed: false } } }

      it 'creates a new todo item' do
        expect {
          post :create, params: { todo_list_id: todo_list_id }.merge(valid_params), format: :json
        }.to change(TodoItem, :count).by(1)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Install Rspec gem')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { todo_item: { name: '' } } }

      it 'returns unprocessable_entity' do
        post :create, params: { todo_list_id: todo_list_id }.merge(invalid_params), format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'GET #edit' do
    context 'when format is JSON' do
      it 'returns the todo item for editing' do
        get :edit, params: { todo_list_id: todo_list_id, id: todo_item_rspec.id }, format: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json['id']).to eq(todo_item_rspec.id)
        expect(json['name']).to eq(todo_item_rspec.name)
        expect(json['todo_list_id']).to eq(todo_list_id)
      end
    end

    context 'when format is HTML' do
      it 'raises routing error' do
        expect {
          get :edit, params: { todo_list_id: todo_list_id, id: todo_item_rspec.id }, format: :html
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:update_params) { { todo_item: { name: 'Updated name' } } }

      it 'updates the todo item' do
        patch :update, params: { todo_list_id: todo_list_id, id: todo_item_rspec.id }.merge(update_params), format: :json

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Updated name')
      end
    end

    context 'with invalid params' do
      let(:invalid_update) { { todo_item: { name: '' } } }

      it 'returns unprocessable_entity' do
        patch :update, params: { todo_list_id: todo_list_id, id: todo_item_rspec.id }.merge(invalid_update), format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the todo item' do
      todo_item = TodoItem.create!(name: 'To be deleted', todo_list_id: todo_list_id)

      expect {
        delete :destroy, params: { todo_list_id: todo_list_id, id: todo_item.id }, format: :json
      }.to change(TodoItem, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
