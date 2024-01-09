dofile "..\\quiz01\\s9770652_commons.lua"

-- Saves for each reachable tile the minimum number of steps required to reach it.
local function traverse(matrix, rows, cols, startRow, startCol)
    local pos = { {startRow, startCol} }
    local steps = {}; for r = 1, rows do steps[r] = {} end
    local i = 0
    while #pos > 0 do
        i = i + 1
        local newpos = {}
        for _, p in ipairs(pos) do
            for _, d in ipairs({ {1,0}, {0,1}, {-1,0}, {0,-1} }) do
                local r, c = p[1] + d[1], p[2] + d[2]
                if 1 <= r and r <= rows and 1 <= c and c <= cols and matrix[r][c] == "." and not steps[r][c] then
                    newpos[#newpos+1] = { r, c }
                    steps[r][c] = i
                end
            end
        end
        pos = newpos
    end
    return steps
end

local matrix, rows, cols = FileToMatrix()
local startRow, startCol
for r = 1, rows do
    for c = 1, cols do
        if matrix[r][c] == "S" then
            matrix[r][c] = "."
            startRow, startCol = r, c
        end
    end
end
local steps = traverse(matrix, rows, cols, startRow, startCol)
-- Draw a square whose endpoints are the centers of each edge of the map.
-- The tiles not within this square shall be the corner of the map.
-- Also, any tile is reachable only in an either even or odd number of steps.
-- `64`: number of tiles reachable in 64 steps. As 64 is even, count all even steps <= 64.
-- `full`: number of tiles reachable in an even/odd number of steps
-- `corners`: number of tiles in the corners in an even/odd number of steps
local reachable = { [64] = 0, fullEven = 0, fullOdd = 0, cornersEven = 0, cornersOdd = 0 }
for _, row in ipairs(steps) do
    for _, step in pairs(row) do
        if step % 2 == 0 then  -- tile reachable in an even number of steps
            reachable.fullEven = reachable.fullEven + 1
            reachable[64] = reachable[64] + ((step < 65 and 1) or 0)
            reachable.cornersEven = reachable.cornersEven + ((step > rows // 2 and 1) or 0)
        else  -- tile reachable in an odd number of steps
            reachable.fullOdd = reachable.fullOdd + 1
            reachable.cornersOdd = reachable.cornersOdd + ((step > rows // 2 and 1) or 0)
        end
    end
end
print(("Nach 64 Schritten kann sich der Elf auf %d verschiedenen Kacheln befinden."):format(  -- solution of first part
    reachable[64]
))

local n = (26501365 - rows // 2) / rows  -- should be `202300`
print(("Nach 26501365 Schritten kann sich der Elf auf %d verschiedenen Kacheln befinden."):format(  -- solution of second part
    (n+1)^2 * reachable.fullOdd +
    n^2 * reachable.fullEven -
    (n+1) * reachable.cornersOdd +
    n * reachable.cornersEven
))