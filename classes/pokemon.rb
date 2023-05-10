require_relative "../pokedex/pokemons"

class Pokemon
  attr_reader :name, :species, :level, :moves, :stats, :experience_points, :base_exp, :effort_points, :battle_hp, :type
  attr_accessor :battle_move

  def initialize(name:, species:, level:)
    @name = name.empty? ? species : name
    @species = species
    @level = level
    @type = Pokedex::POKEMONS[@species][:type]
    @base_exp = Pokedex::POKEMONS[@species][:base_exp]
    @effort_points = Pokedex::POKEMONS[@species][:effort_points]
    @growth_rate = Pokedex::POKEMONS[@species][:growth_rate]
    @base_stats = Pokedex::POKEMONS[@species][:base_stats]
    @moves = Pokedex::POKEMONS[@species][:moves]
    @ivs = { hp: rand(0..31), attack: rand(0..31), defense: rand(0..31), special_attack: rand(0..31),
             special_defense: rand(0..31), speed: rand(0..31) }
    @evs = { hp: 0, attack: 0, defense: 0, special_attack: 0, special_defense: 0, speed: 0 }
    @experience_points = level == 1 ? 0 : Pokedex::LEVEL_TABLES[@growth_rate][@level - 1]
    @stats = calculate_stats(base_stats: @base_stats, ivs: @ivs, evs: @evs, level: @level)
    @battle_hp = nil
    @battle_move = nil
  end

  def prepare_for_battle
    @battle_hp = @stats[:hp]
    @battle_move = nil
  end

  def receive_damage(damage)
    @battle_hp -= damage
  end

  def fainted?
    !@battle_hp.positive?
  end

  def attack(opponent)
    critical = 1
    puts "#{name} used #{@battle_move[:name].upcase}!"
    hit = @battle_move[:accuracy] >= rand(1..100)
    if hit
      if rand(1..16) <= 1
        critical = 1.5
        puts "It was CRITICAL hit!"
      end

      if calc_multiplier(opponent) <= 0.5
        puts "It's not very effective..."
      elsif calc_multiplier(opponent) >= 1.5
        puts "It's super effective!"
      elsif calc_multiplier(opponent).zero?
        puts "It doesn't affect #{opponent.name}!"
      end

      damage = (calc_damage(opponent) * critical * calc_multiplier(opponent)).floor
      opponent.receive_damage(damage)
      puts "And it hit #{opponent.name} with #{damage} damage"
      puts("-" * 50)
    else
      puts "But it MISSED!"
    end
  end

  def increase_stats(defeat_pokemon)
    amount = (defeat_pokemon.base_exp * defeat_pokemon.level / 7.0).floor
    @experience_points += amount
    puts "#{@name} gained #{amount} experience points"
    if @experience_points > Pokedex::LEVEL_TABLES[@growth_rate][@level]
      @level += 1
      puts "#{@name} reached level #{@level}!"
    end
    type = defeat_pokemon.effort_points[:type]
    amount = defeat_pokemon.effort_points[:amount]
    hash = { type => amount } # { speed: 1 }
    @evs.merge!(hash) { |_key, old_value, new_value| old_value + new_value }
    @stats = calculate_stats(base_stats: @base_stats, ivs: @ivs, evs: @evs, level: @level)
  end

  private

  def calc_stat(base_stats:, ivs:, evs:, level:, stat:)
    addend1 = stat == :hp ? level : 0
    addend2 = stat == :hp ? 10 : 5
    (((((2 * base_stats[stat]) + ivs[stat] + evs[stat]) * level) / 100) + addend1 + addend2).floor
  end

  def calculate_stats(base_stats:, ivs:, evs:, level:)
    { hp: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :hp),
      attack: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :attack),
      defense: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :defense),
      special_attack: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :special_attack),
      special_defense: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :special_defense),
      speed: calc_stat(base_stats: base_stats, ivs: ivs, evs: evs, level: level, stat: :speed) }
  end

  def calc_damage(opponent)
    boolean = Pokedex::SPECIAL_MOVE_TYPE.include?(@battle_move[:type])
    attack_type = boolean ? :special_attack : :attack
    defense_type = boolean ? :special_defense : :defense
    ((((2 * @level / 5.0) + 2).floor * @stats[attack_type] * @battle_move[:power] / opponent.stats[defense_type]).floor / 50.0).floor + 2
  end

  def calc_multiplier(opponent)
    multiplier = 1
    Pokedex::TYPE_MULTIPLIER.each do |type|
      next unless type[:user] == @battle_move[:type]

      opponent.type.each do |opponent_type|
        multiplier = type[:multiplier] if type[:target] == opponent_type
      end
    end
    multiplier
  end
end
