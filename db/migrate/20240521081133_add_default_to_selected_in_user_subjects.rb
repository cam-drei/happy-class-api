class AddDefaultToSelectedInUserSubjects < ActiveRecord::Migration[7.1]
  def change
    change_column_default :user_subjects, :selected, from: false, to: true
  end
end
