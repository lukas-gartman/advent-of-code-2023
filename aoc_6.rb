def main
    p part1
    p part2
end

def part1
    time_records = nil
    File.readlines("input/input-6.txt").each_with_index do |line, i|
        val = line.split(" ")[1..].map(&:to_i)
        if time_records.nil?
            time_records = val
        else
            time_records = time_records.zip(val)
        end
    end
    
    winning_combos = []
    for race in time_records
        w_c = []
        t = race[0]
        d_0 = race[1]
        1.upto(t) do |i|
            d_1 = i * (t-i)
            w_c << i if d_1 > d_0
        end
        winning_combos << w_c
    end

    return winning_combos.map(&:length).inject(:*)
end

def part2
    time_records = nil
    File.readlines("input/input-6.txt").each_with_index do |line, i|
        val = line.split(" ")[1..].join("").to_i
        if time_records.nil?
            time_records = [val]
        else
            time_records << val
        end
    end

    winning_combos = []
    w_c = []
    t = time_records[0]
    d_0 = time_records[1]
    1.upto(t) do |i|
        d_1 = i * (t-i)
        w_c << i if d_1 > d_0
    end
    winning_combos << w_c

    return winning_combos.map(&:length).inject(:*)
end

main