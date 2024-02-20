class DropEnrollLessons < ActiveRecord::Migration[7.1]
  def change
    drop_table :enroll_lessons
  end
end
