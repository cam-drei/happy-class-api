class ChangeSelectedDefaultToFalseInCourses < ActiveRecord::Migration[7.1]
  def change
    change_column_default :courses, :selected, from: true, to: false
  end
end
