def main
    p part1
    p part2
end

def part1
    directions = nil
    map = {}
    File.readlines("input/input-8.txt").each_with_index do |line, i|
        if i == 0
            directions = line.chomp.split("") 
            next
        end
        next if i == 1
        
        curr = line.split(" = ")[0]
        left = line.gsub("#{curr} = (", "").split(",")[0]
        right = line.split(", ")[1].gsub(")", "").chomp

        map[curr] = [left, right]
    end

    next_node = "AAA"
    steps = 0
    i = 0
    while i < directions.length
        dir = directions[i]
        break if next_node == "ZZZ"
        next_node = map[next_node][0] if dir == "L"
        next_node = map[next_node][1] if dir == "R"
        
        steps += 1
        i += 1
        i = 0 if i == directions.length
    end
    
    return steps
end

def part2
    directions = nil
    map = {}
    File.readlines("input/input-8.txt").each_with_index do |line, i|
        if i == 0
            directions = line.chomp.split("") 
            next
        end
        next if i == 1
        
        curr = line.split(" = ")[0]
        left = line.gsub("#{curr} = (", "").split(",")[0]
        right = line.split(", ")[1].gsub(")", "").chomp

        map[curr] = {}
        map[curr]["L"] = left
        map[curr]["R"] = right
    end

    next_nodes = map.keys.map {|node| node if node[-1] == "A"}.compact
    nodes_count = Array.new(next_nodes.length, 0)
    i = 0
    steps = 0
    loop do
        dir = directions[i]
        next_nodes.each_with_index do |node, j|
            next if nodes_count[j] != 0
            next_nodes[j] = map[node][dir]
            nodes_count[j] = steps if node[-1] == "Z"
        end

        steps += 1
        i += 1
        break if nodes_count.all? {|x| x != 0}
        i = 0 if i == directions.length
    end

    return nodes_count.reduce(1) { |acc, n| acc.lcm(n) }
end

main