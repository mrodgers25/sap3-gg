class CreateCodes < ActiveRecord::Migration[6.0]
  def change
      create_table :codes do |t|
        t.string :code_type
        t.datetime :code_key
        t.string :code_value

        t.timestamps
    end
  end
end
