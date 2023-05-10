module GetInput
  def get_input(prompt:, msg: "", required: true, color: :default)
    print "#{prompt}: ".colorize(color)
    input = gets.chomp
    return input unless required

    while input.empty?
      puts msg
      print "#{prompt}: ".colorize(color)
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
end
