require "colorize"
require_relative "../modules/utils"
require_relative "player"

class Game
  include Utils

  def initialize
    @player = nil
  end

  def start
    welcome
    action = menu
    until action == "Exit"
      case action
      when "Train"
        train
      when "Leader"
        challenge_leader
      when "Stats"
        show_stats
      else
        puts "Invalid Action"
      end
      action = menu
    end
    goodbye
  end

  private

  def welcome
    puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#\n" \
         "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#\n" \
         "#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#\n" \
         "#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#\n" \
         "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#"
    puts "\nHello there! Welcome to the world of POKEMON! My name is OAK!\n" \
         "People call me the POKEMON PROF!\n\n" \
         "This world is inhabited by creatures called POKEMON! For some\n" \
         "people, POKEMON are pets. Others use them for fights. Myself...\n" \
         "I study POKEMON as a profession."
    name = get_input(prompt: "First, what is your name?", msg: "Write your name")
    puts "Right! So your name is #{name.upcase.colorize(:light_white)}!\n" \
         "\nYour very own POKEMON legend is about to unfold! A world\n" \
         "of dreams and adventures with POKEMON awaits! Let's go!\n" \
         "Here, #{name}! There are 3 POKEMON here! Haha!\n" \
         "When I was young, I was a serious POKEMON trainer.\n"
    initial_pokemon = get_with_options(prompt: "In my old age, I have only 3 left, but you can have one! Choose",
                                       options: ["Bulbasaur", "Charmander", "Squirtle"], msg: "Choose one of the three",
                                       capitalize: true)
    puts "You selected #{initial_pokemon.upcase.colorize(:light_white)}. Great choice!"
    pokemon_name = get_input(prompt: "Give your pokemon a name?", required: false)
    @player = Player.new(name: name, pokemon_name: pokemon_name, species_pokemon: initial_pokemon, level: 1)
    puts "#{@player.name}, raise your young #{@player.pokemon.name} by making it fight!\n" \
         "When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
  end

  def train
    bot = Bot.new
    battle = Battle.new(player: @player, bot: bot)
    puts "\n#{@player.name} challenge #{bot.name} for training"
    battle.start
  end

  def challenge_leader
    leader = Bot.new(name: "Brock", pokemon_name: "", species_pokemon: "Onix", level: 10)
    battle = Battle.new(player: @player, bot: leader)
    puts "\n#{@player.name} challenge the Gym Leader #{leader.name} for a fight!"
    battle.start
  end

  def show_stats
    puts "\n#{@player.pokemon.name}:\n" \
         "Kind: #{@player.pokemon.species}\n" \
         "Level: #{@player.pokemon.level}\n" \
         "Type: #{@player.pokemon.type.join(', ')}\n" \
         "Stats:\n" \
         "HP: #{@player.pokemon.stats[:hp]}\n" \
         "Attack: #{@player.pokemon.stats[:attack]}\n" \
         "Defense: #{@player.pokemon.stats[:defense]}\n" \
         "Special Attack: #{@player.pokemon.stats[:special_attack]}\n" \
         "Special Defense: #{@player.pokemon.stats[:special_defense]}\n" \
         "Speed: #{@player.pokemon.stats[:speed]}\n" \
         "Experience Points: #{@player.pokemon.experience_points}"
  end

  def goodbye
    puts "\nThanks for playing Pokemon Ruby"
    puts "This game was created with love by: Kevin Robles"
  end

  def menu
    puts "#{'-' * 23}Menu#{'-' * 23}\n\n1. Stats        2. Train        3. Leader       4. Exit"
    input = ""
    while input.empty?
      print "> "
      input = gets.chomp.capitalize
    end
    input
  end
end
