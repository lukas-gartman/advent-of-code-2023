def main
    p part1
    p part2
end

def part1
    text = File.readlines('input/input-3.txt')
    numbers = extract_numbers(text)

    total = 0
    for num, coord in numbers
        if check_if_part_num(num, coord, text)
            total += num.to_i
        end
    end
    
    return total
end

def part2
    text = File.readlines('input/input-3.txt')
    numbers = extract_numbers(text)
    gears = get_star_coords(text)

    for num, coord in numbers
        find_gears(num, coord, text, &gears)
    end

    total = 0
    for nums in gears.values
        next if nums.length != 2
        total += nums[0].to_i * nums[1].to_i
    end
    
    return total
end

def numeric?(lookAhead)
    lookAhead.match?(/[[:digit:]]/)
end


def isSymbol?(c)
    return !numeric?(c) && c != "."
end

def extract_numbers(text)
    numbers = []
    num = ""
    text.each_with_index do |line, y|
        line = line.gsub("\n", "")
        line.each_char.with_index do |c, x|
            if numeric?(c)
                num += c
                if x == line.length - 1
                    numbers << [num, [x-(num.length), y]]
                    num = ""
                end
            else
                numbers << [num, [x-(num.length), y]] unless num == ""
                num = ""
            end
        end
    end

    return numbers
end

def check_if_part_num(num, coord, text)
    x = coord[0]
    y = coord[1]

    for a in x-1..x+num.length
        next if a < 0 || a >= text[0].length - 1
        for b in y-1..y+1 
            next if b < 0 || b >= text[0].length - 1
            if isSymbol? text[b][a]
                return true
            end
        end
    end

    return false
end

def get_star_coords(text) # possibly unnecessary ¯\_(ツ)_/¯
    coords = {}
    text.each_with_index do |line, y|
        line.each_char.with_index do |c, x|
            coords[[x,y]] = [] if c == "*"
        end
    end

    return coords
end

def find_gears(num, coord, text, &gears)
    x = coord[0]
    y = coord[1]

    for a in x-1..x+num.length
        next if a < 0 || a >= text[0].length - 1
        for b in y-1..y+1 
            next if b < 0 || b >= text[0].length - 1
            if text[b][a] == "*"
                gears[[a,b]] << num
            end
        end
    end
end

main