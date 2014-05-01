class CreatePokemon < ActiveRecord::Migration
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :type, null: false
      t.integer :hp
      t.integer :attack
      t.integer :defense
      t.boolean :caught, default: false
    end

    add_index :pokemons, :type
  end
end
