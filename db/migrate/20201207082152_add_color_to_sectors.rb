class AddColorToSectors < ActiveRecord::Migration[6.0]
  def change
    add_column :sectors, :color, :string
  end
end
