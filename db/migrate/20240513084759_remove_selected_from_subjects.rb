class RemoveSelectedFromSubjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :subjects, :selected, :boolean
  end
end
