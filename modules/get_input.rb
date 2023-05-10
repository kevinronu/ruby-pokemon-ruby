module GetInput
  def get_input(prompt:, msg: "", required: true)
    print "#{prompt}: ".colorize(:light_cyan)
    input = gets.chomp
    return input unless required

    while input.empty?
      puts msg
      print "#{prompt}: ".colorize(:light_cyan)
      input = gets.chomp
    end
    input
  end
end
