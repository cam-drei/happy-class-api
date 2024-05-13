class RenameDoneToSelectedInUserSubjects < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_subjects, :done, :selected
  end
end
