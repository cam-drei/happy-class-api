class AddUniqueIndexToEnrollCourses < ActiveRecord::Migration[7.1]
  def change
    add_index :enroll_courses, [:user_id, :course_id], unique: true
  end
end
