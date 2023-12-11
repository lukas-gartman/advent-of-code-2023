class Runner
    attr_accessor :pos, :steps, :visited
    def initialize(pos, steps = 0)
        @start_index = pos.dup
        @pos = pos
        @steps = steps
        @visited = []
    end

    def step(dir)
        @steps += 1
        case dir
        when :north then @pos[1] -= 1
        when :east  then @pos[0] += 1
        when :south then @pos[1] += 1
        when :west  then @pos[0] -= 1
        end
        @visited << @pos.dup
        return @pos != @start_index
    end
end

def main
    p part1
    p part2
end

def getDirection(diagram, point, prev_dir)
    tiles = {"|" => :NS, "-" => :EW, "L" => :NE, "J" => :NW, "7" => :SW, "F" => :SE, "." => nil, "S" => :start}
    x, y = point

    curr_pipe = $TILES[diagram[x][y]]
    case curr_pipe
    when :start
        return :north if tiles[diagram[x][y-1]] == :NS
        return :east  if tiles[diagram[x+1][y]] == :EW
        return :south if tiles[diagram[x][y+1]] == :NS
        return :west  if tiles[diagram[x-1][y]] == :EW
    when :NS then return prev_dir == :north ? :north : :south
    when :EW then return prev_dir == :east  ? :east  : :west
    when :NE then return prev_dir == :west  ? :north : :east
    when :NW then return prev_dir == :east  ? :north : :west
    when :SW then return prev_dir == :east  ? :south : :west
    when :SE then return prev_dir == :west  ? :south : :east
    end
end

def getDiagramAndStartIndex
    diagram = []
    start_index = nil
    File.readlines("input/input-10.txt").each_with_index do |line, y|
        diagram << line.chomp.split("")
        if start_index.nil?
            line.each_char.with_index {|c,x| start_index = [x,y] if c == "S"}
        end
    end
    
    return [diagram.transpose, start_index]
end

def part1
    diagram, start_index = getDiagramAndStartIndex()
    r = Runner.new(start_index)
    dir = getDirection(diagram, start_index, nil)
    while r.step(dir)
        dir = getDirection(diagram, r.pos, dir)
    end
    
    return r.steps / 2
end

# https://www.youtube.com/watch?v=RSXM9bgqxJM
def point_in_polygon?(point, path)
    xp, yp = point
    intersections = 0
    for i in 0..(path.length - 1)
        x1, y1 = path[i-1]
        x2, y2 = path[i]
        intersections += 1 if (yp < y1) != (yp < y2) && xp < x1 + ((yp-y1) / (y2-y1)) * (x2-x1)
    end

    return intersections.odd?
end

def part2
    diagram, start_index = getDiagramAndStartIndex()

    r = Runner.new(start_index)
    dir = getDirection(diagram, start_index, nil)
    while r.step(dir)
        dir = getDirection(diagram, r.pos, dir)
    end

    total = 0
    diagram.each_with_index do |a,x|
        a.each_with_index do |b,y|
            next if r.visited.include?([x,y])
            total += 1 if point_in_polygon?([x,y], r.visited)
        end
    end
    return total
end

main