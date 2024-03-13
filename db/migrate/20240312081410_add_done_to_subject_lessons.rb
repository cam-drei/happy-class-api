class AddDoneToSubjectLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :subject_lessons, :done, :boolean, default: false
  end
end
