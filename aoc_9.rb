def main
    p part1
    p part2
end

def part1
    total = 0
    File.readlines("input/input-9.txt").each_with_index do |line, i|
        line = line.chomp.split(" ").map(&:to_i)
        diffs = [line]
        while true
            diffs << diffs[-1].each_cons(2).map {|x,y| y - x}
            break if diffs[-1].all? {|x| x == 0}
        end

        total += diffs.map {|x| x[-1]}.sum
    end

    return total
end

def part2
    total = 0
    File.readlines("input/input-9.txt").each_with_index do |line, i|
        line = line.chomp.split(" ").map(&:to_i)
        diffs = [line]
        while true
            diffs << diffs[-1].each_cons(2).map {|x,y| x - y}
            break if diffs[-1].all? {|x| x == 0}
        end

        total += diffs.map {|x| x[0]}.sum
    end

    return total
end

main