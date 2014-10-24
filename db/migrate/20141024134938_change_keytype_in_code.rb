class ChangeKeytypeInCode < ActiveRecord::Migration
  def change
    change_column :codes, :code_key, :string
  end
end
