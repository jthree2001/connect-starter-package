class AddZIdToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :zuora_id, :string
  end
end
