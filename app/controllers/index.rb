get '/' do
  #Searching
  @captured_pokemon = Pokemon.where(caught: true).order(:type)
  @free_pokemon = Pokemon.where(caught: false).order(:type)

  @types = %w(
    bug dark dragon electric fairy fighting fire flying
    ghost grass ground ice normal poison psychic rock
    shadow steel unknown water
  )

  erb :index
end

post '/catch/:id' do
  @types = %w(
    bug dark dragon electric fairy fighting fire flying
    ghost grass ground ice normal poison psychic rock
    shadow steel unknown water
  )
  #Validations: Allowed to catch pokemon that follow the following rules:
  # you don't already have it
  # you don't already have 2 pokemon of that type
  found_pokemon = Pokemon.where(id: params[:id]).first
  caught_count = Pokemon.where(type: found_pokemon.type, caught: true).count

  if caught_count < 2 && @types.include?( found_pokemon.type )
    found_pokemon.caught = true
    found_pokemon.save
    puts "Hey! Friends! I caught #{found_pokemon.name.upcase}!"
  else
    puts "Had to let #{found_pokemon.name.upcase} go. :'("
  end

  redirect '/'
end

post '/release/:id' do
  found_pokemon = Pokemon.where(id: params[:id]).first
  found_pokemon.caught = false
  found_pokemon.save

  redirect '/'
end