class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.integer :clasification_type
      t.json :entities
      t.json :clasifications
      t.integer :status

      t.timestamps
    end
  end
end
