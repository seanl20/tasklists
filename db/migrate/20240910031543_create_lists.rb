class CreateLists < ActiveRecord::Migration[7.2]
  def change
    create_table :lists, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :private
      t.boolean :shared
      t.datetime :shared_at
      
      t.references :user, null: false, type: :uuid, foreign_key: true
    end
  end
end
