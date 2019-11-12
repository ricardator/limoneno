class AddRawTextToDatasetItems < ActiveRecord::Migration[6.0]
  def change
    add_column :dataset_items, :raw_text, :text
  end
end
