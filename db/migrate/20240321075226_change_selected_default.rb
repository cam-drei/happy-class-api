class ChangeSelectedDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :subjects, :selected, true
  end
end
