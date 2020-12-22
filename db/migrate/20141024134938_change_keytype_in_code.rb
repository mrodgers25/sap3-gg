class ChangeKeytypeInCode < ActiveRecord::Migration[6.0]
  def change
    change_column :codes, :code_key, :string
  end
end
