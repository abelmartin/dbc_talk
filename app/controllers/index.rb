get '/' do
  #Searching
  @captured_pokemon = Pokemon.where(caught: true)
  @free_pokemon = Pokemon.where(caught: false)

  @types = %w(
    Bug Dark Dragon Electric Fairy Fighting Fire Flying
    Ghost Grass Ground Ice Normal Poison Psychic Rock
    Shadow Steel Unknown Water
  )

  erb :index
end

post '/catch/:id' do
  #Validations: Allowed to catch pokemon that follow the following rules:
  # you don't already have it
  # you don't already have 2 pokemon of that type
  found_pokemon = Pokemon.where(id: id)
  caught_count = Pokemon.where(type: found_pokemon.type).count
  if caught_count <= 2
    found_pokemon.caught = true
    found_pokemon.save
    puts "Hey! Friends! I caught #{found_pokemon.name.upcase}!"
  else
    puts "Had to let #{found_pokemon.name.upcase} go. :'("
  end

  erb :index
end