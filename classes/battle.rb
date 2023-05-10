require_relative "../modules/get_input"

class Battle
  include GetInput

  def initialize(player:, bot:)
    @player = player
    @bot = bot
    @player_pok = @player.pokemon
    @bot_pok = @bot.pokemon
  end

  def start
    @player_pok.prepare_for_battle
    @bot_pok.prepare_for_battle
    puts "#{@bot.name} has a #{@bot_pok.name} level #{@bot_pok.level}"
    decision = get_with_options(prompt: "\nWhat do you want to do now?", options: ["fight", "leave"])
    if decision == "fight"
      initial_battle
      battle_loop

      winner = @player_pok.fainted? ? @bot_pok : @player_pok
      loser = winner == @player_pok ? @bot_pok : @player_pok

      puts "#{loser.name} FAINTED!"
      puts "--------------------------------------------------"
      puts "#{winner.name} WINS!"
      winner.increase_stats(loser) if winner == @player_pok
      puts "-------------------Battle Ended!-------------------"
      if winner == @player_pok && @bot.name == "Brock"
        puts "Congratulation! You have won the game!\n" \
             "You can continue training your Pokemon if you want"
      end
    else
      puts "#{@player.name} escape from the battle"
    end
  end

  private

  def battle_loop
    until @player_pok.fainted? || @bot_pok.fainted?
      @player.select_move
      @bot.select_move

      first = select_first(@player_pok, @bot_pok)
      second = first == @player_pok ? @bot_pok : @player_pok

      puts ("-" * 50).to_s
      first.attack(second)
      second.attack(first) unless second.fainted?
      break if @player_pok.fainted? || @bot_pok.fainted?

      puts "\n#{@player.name}'s #{@player_pok.name} - Level #{@player_pok.level}"
      puts "HP: #{@player_pok.hp}"
      puts "#{@bot.name}'s #{@bot_pok.name} - Level #{@bot_pok.level}"
      puts "HP: #{@bot_pok.hp}\n\n"
    end
  end

  def select_first(player_pok:, bot_pok:)
    player_move = player_pok.move
    bot_move = bot_pok.move

    return player_pok if player_move[:priority] > bot_move[:priority]
    return bot_pok if player_move[:priority] < bot_move[:priority]

    if player_pok.stats[:speed] > bot_pok.stats[:speed]
      player_pok
    elsif player_pok.stats[:speed] < bot_pok.stats[:speed]
      bot_pok
    else
      [player_pok, bot_pok].sample
    end
  end

  def initial_battle
    puts "#{@bot.name}'s sent out #{@bot_pok.name.upcase}!"
    puts "#{@player.name}'s sent out #{@player_pok.name.upcase}!"
    puts "#{'-' * 19}Battle Start!#{'-' * 19}"
    puts "\n#{@player.name}'s #{@player_pok.name} - Level #{@player_pok.level}"
    puts "HP: #{@player_pok.hp}"
    puts "#{@bot.name}'s #{@bot_pok.name} - Level #{@bot_pok.level}"
    puts "HP: #{@bot_pok.hp}\n\n"
  end
end
