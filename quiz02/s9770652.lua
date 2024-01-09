local bag = { red = 12, green = 13, blue = 14 }
local ids = 0
local powers = 0
for line in io.lines("s9770652.txt") do
    local possible = true
    local max = { red = 0, green = 0, blue = 0 }
    for colour, _ in pairs(bag) do
        for number in line:gmatch("(%d*) " .. colour) do
            possible = possible and tonumber(number) <= bag[colour]
            max[colour] = math.max(max[colour], tonumber(number))
        end
    end
    if possible then
        ids = ids + line:match("Game (%d*)")
    end
    powers = powers + max.red * max.green * max.blue
end

print(("Die Summe der IDs betraegt %d."):format(ids))
print(("Die Summe der Maechtigkeiten betraegt %d."):format(powers))