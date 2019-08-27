class CreateDatasetItems < ActiveRecord::Migration[6.0]
  def change
    create_table :dataset_items do |t|
      t.integer :dataset_id
      t.string :name
      t.string :mime
      t.text :text
      t.json :metadata
      t.text :url
      t.integer :status
      t.boolean :stored

      t.timestamps
    end
  end
end
