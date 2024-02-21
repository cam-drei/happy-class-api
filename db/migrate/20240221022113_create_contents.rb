class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :video_link
      t.string :document_link
      t.string :resource_type
      t.integer :resource_type_id

      t.timestamps
    end
  end
end
