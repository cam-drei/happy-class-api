class RemoveDoneFromLessons < ActiveRecord::Migration[7.1]
  def change
    remove_column :lessons, :done, :boolean
  end
end
