def main
    p calc_distance(1) # part 1
    p calc_distance(999999) # part 2
end

def count_empty_lines(input)
    empty_lines = [[], []]
    2.times do |num|
        for i in 0..(input.length - 1)
            empty_lines[num] << i if input[i].count("#") == 0
        end
        break if num == 1
        input = input.map {|x| x.split("")}.transpose.map {|x| x.join("")}
    end

    return empty_lines
end

def calc_distance(expansion_size)
    input = File.readlines("input/input-11.txt").map(&:chomp)
    empty_lines = count_empty_lines(input)

    indices = []
    input.each_with_index do |x, i|
        x.each_char.with_index do |c, j|
            if c == "#"
                point = [i,j]
                point[0] += expansion_size * empty_lines[0].count {|v| v < i}
                point[1] += expansion_size * empty_lines[1].count {|v| v < j}
                indices << point
            end
        end
    end

    return indices.combination(2).map {|p1, p2| (p2[0] - p1[0]).abs + ((p2[1]) - p1[1]).abs}.sum
end

main