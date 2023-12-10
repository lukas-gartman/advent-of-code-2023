def main
    p part1
    p part2
end

def part1
    card_values = {"A" => 14, "K" => 13, "Q" => 12, "J" => 11, "T" => 10}
    types = Hash.new{|hash, key| hash[key] = []}
    input = File.readlines("input/input-7.txt").each_with_index do |line, i|
        hand = line.chomp.split(" ")
        
        count_cards = Hash.new(0)
        hand[0].each_char.with_index do |card, i|
            count_cards[card] += 1
        end

        sorted_count_cards = count_cards.sort_by {|k,v| v}.reverse!.to_a
        card = sorted_count_cards[0]
        next_card = sorted_count_cards[1]
        if card[1] == 5
            types[FIVE_OF_A_KIND] << hand
        elsif card[1] == 4
            types[FOUR_OF_A_KIND] << hand
        elsif card[1] == 3
            types[FULL_HOUSE] << hand if next_card[1] == 2
            types[THREE_OF_A_KIND] << hand if next_card[1] == 1
        elsif card[1] == 2
            types[TWO_PAIR] << hand if next_card[1] == 2
            types[ONE_PAIR] << hand if next_card[1] < 2
        elsif card[1] == 1
            types[HIGH_CARD] << hand
        end
    end

    ranks = input.length
    total = 0
    new_order = []
    types = types.sort_by {|key| key}.reverse!
    for type, cards in types
        cards = cards.map {|cs, val| [cs, val, cs.chars.map {|c| card_values[c] || c.to_i}]}.sort_by { |item| item[2] }.map {|x,y,z| [x,y]}.reverse
        for c in cards
            new_order << c
        end
    end

    for c in new_order
        total += c[1].to_i * ranks
        ranks -= 1
    end

    return total
end

def part2
    card_values = {"A" => 14, "K" => 13, "Q" => 12, "T" => 10, "J" => -1}
    
    types = Hash.new{|hash, key| hash[key] = []}
    input = File.readlines("input/input-7.txt").each_with_index do |line, i|
        hand = line.chomp.split(" ")

        count_cards = Hash.new(0)
        hand[0].each_char {|card| count_cards[card] += 1 unless card == "J"}
        sorted_count_cards = count_cards.sort_by {|k,v| v}.reverse!.to_a

        if sorted_count_cards.length == 0
            first_card_count = hand[0].count("J")
        else
            first_card_count = sorted_count_cards[0][1] + hand[0].count("J") 
        end

        if first_card_count < 5
            next_card_count = sorted_count_cards[1][1]
        end

        if first_card_count == 5
            types[FIVE_OF_A_KIND] << hand
        elsif first_card_count == 4
            types[FOUR_OF_A_KIND] << hand
        elsif first_card_count == 3
            types[FULL_HOUSE] << hand if next_card_count == 2
            types[THREE_OF_A_KIND] << hand if next_card_count == 1
        elsif first_card_count == 2
            types[TWO_PAIR] << hand if next_card_count == 2
            types[ONE_PAIR] << hand if next_card_count < 2
        elsif first_card_count == 1
            types[HIGH_CARD] << hand
        end
    end

    ranks = input.length
    total = 0
    new_order = []
    types = types.sort_by {|key| key}.reverse!
    for type, cards in types
        cards = cards.map {|hand, val| [hand.chars.map {|x| card_values[x] || x.to_i}, val]}.sort.reverse.map {|hand, val| [hand.map {|x| card_values.key(x) || x.to_s}.join(""), val]}
        for c in cards
            new_order << c
        end
    end

    for c in new_order
        total += c[1].to_i * ranks
        ranks -= 1
    end

    return total
end

FIVE_OF_A_KIND = 6
FOUR_OF_A_KIND = 5
FULL_HOUSE = 4
THREE_OF_A_KIND = 3
TWO_PAIR = 2
ONE_PAIR = 1
HIGH_CARD = 0

main