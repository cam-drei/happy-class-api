class AddSelectedToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :selected, :boolean, default: true
  end
end
