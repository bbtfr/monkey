require 'monkey'
require 'pry'

monkey = Monkey.new verbose: true do
  def go_left
    swipe 1000, 1500, 0, 1500
  end
  def go_right
    swipe 0, 1500, 1000, 1500
  end
  def attack
    tap 500, 1500
  end
end

loop do
  8.times do
    monkey.attack
  end
  monkey.go_left
  monkey.go_left
  8.times do
    monkey.attack
  end
  monkey.go_right
end

# loop do
#   monkey.attack
# end
