class RenameLessonIdColumnInUserLessons < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_lessons, :lessons_id, :lesson_id
  end
end
