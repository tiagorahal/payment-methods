# frozen_string_literal: true

class CreateBoletos < ActiveRecord::Migration[7.1]
  def change
    create_table :boletos do |t|
      t.string :codigo
      t.date :vencimento
      t.decimal :valor

      t.timestamps
    end
  end
end
