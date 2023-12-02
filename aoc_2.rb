def main
    part1
    part2
end

def part1
    games = []
    File.readlines('input/input-2.txt').each do |line|
        gamesets = line.split(": ")[1].split("; ")
        isValid = true
        for set in gamesets
            kv = set.split(", ")
            for x in kv
                y = x.split(" ")
                num = y[0].to_i
                colour = y[1]
                
                if (colour == "red" && num > 12) || (colour == "green" && num > 13) || (colour == "blue" && num > 14)
                    isValid = false
                    break
                end
            end
            break if !isValid
        end

        games << isValid
    end

    sum = 0
    games.each_with_index do |valid, i|
        sum += i+1 if valid
    end

    p sum
end

def part2
    games = []
    File.readlines('input/input-2.txt').each do |line|
        gamesets = line.split(": ")[1].split("; ")
        colour_min = {"red" => 0, "green" => 0, "blue" => 0}
        for set in gamesets
            kv = set.split(", ")
            for x in kv
                y = x.split(" ")
                num = y[0].to_i
                colour = y[1]
                if colour_min[colour] < num
                    colour_min[colour] = num.to_i
                end
            end
        end

        games << [colour_min["red"], colour_min["green"], colour_min["blue"]]
    end

    power = 0
    for game in games
        power += game[0] * game[1] * game[2]
    end

    p power
end

main