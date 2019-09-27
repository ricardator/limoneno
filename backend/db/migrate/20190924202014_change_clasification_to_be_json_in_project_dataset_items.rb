class ChangeClasificationToBeJsonInProjectDatasetItems < ActiveRecord::Migration[6.0]
  def change
    change_column :project_dataset_items, :clasification, :json
    add_column :project_dataset_items, :documents, :boolean
  end
end
