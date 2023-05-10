# require neccesary files
require_relative "../modules/get_input"
require_relative "../pokedex/moves"
require_relative "../pokedex/pokemons"
require_relative "pokemon"
require_relative "battle"

class Player
  include GetInput
  attr_reader :pokemon, :name

  def initialize(name:, pokemon_name:, species_pokemon:, level:)
    @name = name
    @pokemon = Pokemon.new(name: pokemon_name, species: species_pokemon, level: level)
  end

  def select_move
    move = get_with_options(prompt: "#{@name}, select your move:", options: @pokemon.moves)
    @pokemon.move = Pokedex::MOVES[move]
  end
end

class Bot < Player
  def initialize
    options = Pokedex::POKEMONS.keys
    random_pokemon = options.sample
    super(name: "Random Person", pokemon_name: "", species_pokemon: random_pokemon, level: rand(1..5))
  end

  def select_move
    move = @pokemon.moves.sample
    @pokemon.move = Pokedex::MOVES[move]
  end
end
