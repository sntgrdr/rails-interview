class CreateTodoItems < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_items do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :done, null: false, default: false
      t.belongs_to :todo_list

      t.timestamps
    end
  end
end
