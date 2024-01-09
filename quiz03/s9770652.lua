function CheckAdjacents(matrix, gears, start, ending, width, length)
    local x1 = math.fmod(start, width)
    local x2 = math.fmod(ending, width)
    local y = start // width + 1

    for i = math.max(x1-1, 1), math.min(x2+1, width-2) do
        for j = math.max(y-1, 1), math.min(y+1, length) do
            local index = (j-1)*width + i
            local neighbour = matrix:sub(index, index)
            if neighbour ~= "." and neighbour:find("%D") then
                if neighbour == "*" then
                    if gears[index] == nil then
                        gears[index] = { tonumber(matrix:sub(start, ending)) }
                    else
                        table.insert(gears[index], tonumber(matrix:sub(start, ending)))
                    end
                end
                return tonumber(matrix:sub(start, ending))
            end
        end
    end
    return 0
end

local f = assert(io.open("s9770652.txt", "r"))
local s = f:read("all")
f:close()

local _, width = s:find("\n")
local _, length = s:gsub("\n", "\n")

local parts = 0
local gears = {}
local seek = 1
while true do
    local start, ending = s:find("%d+", seek)
    if start == nil then break end
    parts = parts + CheckAdjacents(s, gears, start, ending, width, length)
    seek = ending + 1
end
print(("Die Summe der Einzelteilzahlen betraegt %d."):format(parts))

local ratios = 0
for _, v in pairs(gears) do
    if #v == 2 then
        ratios = ratios + v[1] * v[2]
    end
end
print(("Die Summe der Zahnradverhaeltnisse betraegt %d."):format(ratios))