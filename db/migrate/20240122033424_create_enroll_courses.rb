class CreateEnrollCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :enroll_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
