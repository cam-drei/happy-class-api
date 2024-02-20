class AddDoneToLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :done, :boolean, default: false
  end
end
