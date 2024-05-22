class CreateUserSubjectLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :user_subject_lessons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subject_lesson, null: false, foreign_key: true
      t.boolean :done, default: false

      t.timestamps
    end

    add_index :user_subject_lessons, [:user_id, :subject_lesson_id], unique: true
  end
end
