class CreateSubjectLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :subject_lessons do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
    add_index :subject_lessons, [:subject_id, :lesson_id], unique: true
  end
end
