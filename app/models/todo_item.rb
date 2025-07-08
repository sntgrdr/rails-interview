class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates :name, presence: true

  scope :completed, -> { where(completed: true) }
  scope :uncompleted, -> { where(completed: false) }
end
