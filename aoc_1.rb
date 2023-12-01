def main
    part1
    part2
end

def numeric?(lookAhead)
    lookAhead.match?(/[[:digit:]]/)
end

def part1
    numbers = []
    File.readlines('input/input-1.txt').each do |line|
        firstnum = -1
        secondnum = -1
        combined = ""
        line.each_char do |c|
            if numeric?(c)
                firstnum = c.to_i
                combined += c
                break
            end
        end
        line.reverse.each_char do |c|
            if numeric?(c)
                secondnum = c.to_i
                combined += c
                break
            end
        end

        numbers << combined
    end

    total = 0
    for num in numbers
        total += num.to_i
    end
    p total
end

def part2
    numbervals = {"one" => "1", "two" => "2", "three" => "3", "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8", "nine" => "9", "zero" => "0"}
    
    numbers = []
    File.readlines('input/input-1.txt').each do |line|
        num1 = getNum(line, false)
        if numbervals[num1] != nil
            num1 = numbervals[num1]
        end
        num2 = getNum(line, true)
        if numbervals[num2] != nil
            num2 = numbervals[num2]
        end
        numbers << num1 + num2
    end

    total = 0
    for num in numbers
        total += num.to_i
    end
    p total
end

def getNum(line, isReverse)
    if isReverse
        line = line.reverse
    end
    
    if numeric?(line[0])
        return line[0]
    end

    nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero"]

    number = ""
    lowestIndex = line.length
    for n in nums
        if isReverse
            n = n.reverse
        end

        index = line.index(n)
        if index != nil
            if index < lowestIndex
                lowestIndex = index
                number = n
            end
        end
    end

    line.each_char do |c|
        if numeric? c
            index = line.index(c)
            if index < lowestIndex
                lowestIndex = index
                number = c
            end
        end
    end

    if isReverse
        newnum = number.reverse
    else
        return number
    end
end

main