class RemoveLessonIdFromSubjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :subjects, :lesson_id, :bigint
  end
end
