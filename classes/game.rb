require "colorize"
require_relative "../modules/get_input"
require_relative "player"

class Game
  include GetInput

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
    name = get_input(prompt: "First, what is your name?")
    puts "Right! So your name is #{name.upcase}!\n" \
         "Your very own POKEMON legend is about to unfold! A world\n" \
         "of dreams and adventures with POKEMON awaits! Let's go!\n" \
         "Here, #{name}! There are 3 POKEMON here! Haha!\n" \
         "When I was young, I was a serious POKEMON trainer.\n"
    initial_pokemon = get_with_options(prompt: "In my old age, I have only 3 left, but you can have one! Choose",
                                       options: ["Bulbasaur", "Charmander", "Squirtle"], msg: "Invalid option",
                                       capitalize: true)
    puts "You selected #{initial_pokemon.upcase}. Great choice!"
    pokemon_name = get_input(prompt: "Give your pokemon a name?")
    @player = Player.new(name: name, pokemon_name: pokemon_name, species_pokemon: initial_pokemon, level: 1)
    puts "#{name.upcase}, raise your young #{@player.pokemon.name.upcase} by making it fight!\n" \
         "When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
  end

  def train
    bot = Bot.new
    battle = Battle.new(@player, bot)
    puts "\n#{@player.name} challenge #{bot.name} for training"
    battle.start
  end

  def challenge_leader
    leader = Player.new("Brock", "", "Onix", 10)
    battle = Battle.new(@player, leader)
    puts "\n#{@player.name} challenge the Gym Leader #{leader.name} for a fight!"
    battle.start
  end

  def show_stats
    puts "\n#{@player.pokemon.name}:" \
         "Kind: #{@player.pokemon.species}" \
         "Level: #{@player.pokemon.level}" \
         "Type: fire" \
         "Stats:" \
         "HP: #{@player.pokemon.stats[:hp]}" \
         "Attack: #{@player.pokemon.stats[:attack]}" \
         "Defense: #{@player.pokemon.stats[:defense]}" \
         "Special Attack: #{@player.pokemon.stats[:special_attack]}" \
         "Special Defense: #{@player.pokemon.stats[:special_defense]}" \
         "Speed: #{@player.pokemon.stats[:speed]}" \
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
