class Card
    attr_reader :card_num, :winning_numbers, :my_numbers, :numbers_won
    
    def initialize(card_num, winning_numbers, my_numbers)
        @card_num = card_num
        @winning_numbers = winning_numbers
        @my_numbers = my_numbers
        @numbers_won = (winning_numbers & my_numbers).sort
    end
end

def main
    p part1
    p part2
end

def part1
    total = 0
    File.readlines('input/input-4.txt').each do |line|
        line = line.split(": ")[1].split(" | ")
        winning = line[0].strip.split(" ").map(&:to_i)
        my_numbers = line[1].strip.split(" ").map(&:to_i)

        intersection = winning & my_numbers
        total += 2 ** ((intersection).length - 1) unless intersection.length < 1
    end

    return total
end

def part2
    cards = {}
    File.readlines('input/input-4.txt').each do |line|
        card_num = line.gsub("Card ", "").split(":")[0].to_i
        line = line.split(": ")[1].split(" | ")
        winning = line[0].strip.split(" ").map(&:to_i)
        my_numbers = line[1].strip.split(" ").map(&:to_i)

        cards[card_num] = Card.new(card_num, winning, my_numbers)
    end

    queue = []
    copies = []
    loop do
        if queue.empty?
            for card in cards.values
                queue << card
            end
        end

        c = queue.pop()
        copies << c
        num_of_copies = c.numbers_won.length
        num_of_copies.times do |j|
            offset = j+1
            queue << cards[c.card_num + offset].clone
        end

        break if queue.empty?
    end

    return copies.length
end

main