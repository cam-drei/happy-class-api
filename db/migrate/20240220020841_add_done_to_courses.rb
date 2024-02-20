class AddDoneToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :done, :boolean, default: false
  end
end
