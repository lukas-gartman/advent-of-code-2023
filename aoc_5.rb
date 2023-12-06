def main
    # p part1
    p part2
end

def numeric?(lookAhead)
    lookAhead.match?(/[[:digit:]]/)
end

def interpret_map(map, value)
    for x in map
        source = x[1]
        destination = x[0]
        range = x[2]
        if value.between?(source, source+range-1)
            diff = value - source
            return destination+diff
        end
    end
    return value
end

def part1
    seeds = nil
    curr_map = ""
    maps = Hash.new([])
    File.readlines("input-5.txt").each_with_index do |line, i|
        line = line.split(" ")
        if i == 0
            seeds = line[1..].map(&:to_i)
            next
        end

        next if line.empty?
        if !numeric? line[0]
            curr_map = line[0]
            next
        end
        
        if maps[curr_map].empty?
            maps[curr_map] = [line.map(&:to_i)]
        else
            maps[curr_map] << line.map(&:to_i)
        end
    end

    seed_location = {}
    for seed in seeds
        soil = interpret_map(maps["seed-to-soil"], seed)
        fertilizer = interpret_map(maps["soil-to-fertilizer"], soil)
        water = interpret_map(maps["fertilizer-to-water"], fertilizer)
        light = interpret_map(maps["water-to-light"], water)
        temperature = interpret_map(maps["light-to-temperature"], light)
        humidity = interpret_map(maps["temperature-to-humidity"], temperature)
        location = interpret_map(maps["humidity-to-location"], humidity)
        seed_location[seed] = location
    end

    lowest_location = seed_location.values.min
    return lowest_location
end

def get_x_to_y(x, map)
    map.each_with_index do |v, i|
        source = v[1]
        dest = v[0]
        len = v[2]
        
        if x >= source && x < (source + len)
            diff = x - source
            return dest + diff
        end
    end

    return x
end

def get_location(seed, maps)
    soil = get_x_to_y(seed, maps["seed-to-soil"])
    fertilizer = get_x_to_y(soil, maps["soil-to-fertilizer"])
    water = get_x_to_y(fertilizer, maps["fertilizer-to-water"])
    light = get_x_to_y(water, maps["water-to-light"])
    temperature = get_x_to_y(light, maps["light-to-temperature"])
    humidity = get_x_to_y(temperature, maps["temperature-to-humidity"])
    location = get_x_to_y(humidity, maps["humidity-to-location"])
    return location
end

def work(seed, seed_length, maps)
    seed_length = seed % seed_length
    $threads << Thread.new {
        puts "Thread working on #{seed}"
        temp_low = INT_MAX
        s = seed
        while s < seed + seed_length
            location = get_location(s, maps)
            temp_low = location if location < temp_low
            s += 1
        end

        $mutex.synchronize {
            $lowest_location = temp_low if temp_low < $lowest_location
        }
    }
end

def part2
    seeds = nil
    curr_map = ""
    maps = Hash.new([])
    File.readlines("input-5.txt").each_with_index do |line, i|
        line = line.split(" ")
        if i == 0
            seeds = line[1..].map(&:to_i).each_slice(2).to_a.sort_by! {|x| x[0]}
            next
        end

        next if line.empty?
        if !numeric? line[0]
            curr_map = line[0]
            next
        end
        
        if maps[curr_map].empty?
            maps[curr_map] = [line.map(&:to_i)]
        else
            maps[curr_map] << line.map(&:to_i)
        end
    end

    for key in maps.keys
        maps[key].sort_by! {|values| values[1]}
    end

    for s in seeds
        seed = s[0]
        len  = s[1]
        work(seed, len, maps) # process in separate thread
    end
    $threads.map(&:join)

    return $lowest_location
end

N_BYTES = [42].pack('i').size
N_BITS = N_BYTES * 16
INT_MAX = 2 ** (N_BITS - 2) - 1

$threads = []
$mutex = Mutex.new
$lowest_location = INT_MAX

main