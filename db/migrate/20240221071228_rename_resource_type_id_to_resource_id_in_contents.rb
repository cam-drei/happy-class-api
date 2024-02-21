class RenameResourceTypeIdToResourceIdInContents < ActiveRecord::Migration[7.1]
  def change
    rename_column :contents, :resource_type_id, :resource_id
  end
end
