class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :reference
      t.integer :reference_id
      t.text :note

      t.timestamps
    end
  end
end
