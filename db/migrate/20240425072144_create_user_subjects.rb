class CreateUserSubjects < ActiveRecord::Migration[7.1]
  def change
    create_table :user_subjects do |t|
      t.references :user, foreign_key: true
      t.references :subject, foreign_key: true
      t.boolean :done, default: false

      t.timestamps
    end

    add_index :user_subjects, [:user_id, :subject_id], unique: true
  end
end
