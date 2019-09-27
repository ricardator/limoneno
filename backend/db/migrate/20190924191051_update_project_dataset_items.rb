class UpdateProjectDatasetItems < ActiveRecord::Migration[6.0]
  def change
    change_column :project_dataset_items, :clasification, :text, size: :long
  end
end
