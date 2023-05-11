module Utils
  def get_input(prompt:, msg: "", required: true)
    puts prompt
    print "> "
    input = gets.chomp
    return input unless required

    while input.empty?
      puts msg
      puts prompt
      print "> "
      input = gets.chomp
    end
    input
  end

  def print_options(options)
    options.each.with_index do |option, index|
      print "#{index + 1}. #{option.capitalize}      "
    end
    puts ""
  end

  def get_with_options(prompt:, options:, msg: "", capitalize: false)
    puts prompt
    print_options(options)
    print "> "
    input = gets.chomp.downcase
    input = input.capitalize if capitalize
    until options.include?(input)
      puts msg
      print_options(options)
      print "> "
      input = gets.chomp.downcase
      input = input.capitalize if capitalize
    end
    puts ""
    input
  end

  def pokemon_color(type)
    case type[0]
    when :grass
      :light_green
    when :fire
      :light_red
    when :water
      :light_blue
    when :electric
      :light_yellow
    when :rock
      :black
    else
      :light_white
    end
  end
end
