class RemoveDoneFromCourses < ActiveRecord::Migration[7.1]
  def change
    remove_column :courses, :done, :boolean
  end
end
