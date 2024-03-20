class RenameDoneColumnInSubjects < ActiveRecord::Migration[7.1]
  def change
    rename_column :subjects, :done, :selected
  end
end
