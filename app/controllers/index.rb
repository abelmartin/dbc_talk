enable :sessions
use Rack::Flash

get '/' do
  @types = Pokemon::TYPES
  @captured_pokemon, @free_pokemon = Pokemon.caught_vs_free(params[:type])

  erb :index
end

post '/catch/:id' do
  found_pokemon = Pokemon.find(params[:id])

  found_pokemon.capture
  flash[:notice] = found_pokemon.capture_message

  redirect_with_type
end

post '/release/:id' do
  found_pokemon = Pokemon.find(params[:id])

  found_pokemon.release
  flash[:notice] = found_pokemon.release_message

  redirect_with_type
end

def redirect_with_type
  if params[:type].present?
    redirect "/?type=#{params[:type]}"
  else
    redirect '/'
  end
end