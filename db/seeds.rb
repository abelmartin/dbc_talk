ActiveRecord::Base.connection.execute("TRUNCATE TABLE pokemons RESTART IDENTITY")

(1..151).each do |n|
  poke_data = HTTParty.get("http://pokeapi.co/api/v1/pokemon/#{n}")
  first_type = poke_data['types'].map{|t| t['name'].to_sym}.first

  if Pokemon.where(type: first_type).count > 3
    puts "SKIPPING #{poke_data['name']}.  Hit '#{first_type}' limit"
    next
  end

  Pokemon.create do |pk|
    pk.name = poke_data['name']
    pk.type = poke_data['types'].map{|t| t['name'].to_sym}.first
    pk.hp = poke_data['hp']
    pk.attack = poke_data['attack']
    pk.defense = poke_data['defense']
  end

  ##Wild DBC Pokemon
end