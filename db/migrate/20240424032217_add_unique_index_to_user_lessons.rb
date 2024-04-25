class AddUniqueIndexToUserLessons < ActiveRecord::Migration[7.1]
  def change
    add_index :user_lessons, [:user_id, :lesson_id], unique: true
  end
end
