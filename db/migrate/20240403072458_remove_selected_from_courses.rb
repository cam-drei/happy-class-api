class RemoveSelectedFromCourses < ActiveRecord::Migration[7.1]
  def change
    remove_column :courses, :selected, :boolean
  end
end
