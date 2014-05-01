enable :sessions
use Rack::Flash

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
    NotificationService.tell_friends "I caught #{found_pokemon.name.upcase}!"
  else
    flash[:notice] = "damn Damn DAMN! #{found_pokemon.name.upcase} got away!"
  end

  redirect '/'
end

post '/release/:id' do
  found_pokemon = Pokemon.where(id: params[:id]).first
  found_pokemon.caught = false
  found_pokemon.save

  release_message = "#{found_pokemon.name} was released back into the wild"
  flash[:notice] = release_message
  NotificationService.tell_friends release_message

  redirect '/'
end