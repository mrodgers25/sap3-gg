class AddAncestryToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :ancestry, :string
    add_index :categories, :ancestry
  end
end
