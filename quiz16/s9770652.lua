dofile "..\\quiz01\\s9770652_commons.lua"

local DIRS = Enum{"NORTH", "EAST", "SOUTH", "WEST"}
local MIRRORS = {
    ["."]  = { [DIRS.NORTH] = {DIRS.SOUTH}, [DIRS.SOUTH] = {DIRS.NORTH},  [DIRS.EAST] = {DIRS.WEST}, [DIRS.WEST] = {DIRS.EAST} },
    ["/"]  = { [DIRS.SOUTH] = {DIRS.EAST},   [DIRS.EAST] = {DIRS.SOUTH}, [DIRS.NORTH] = {DIRS.WEST}, [DIRS.WEST] = {DIRS.NORTH} },
    ["\\"] = { [DIRS.NORTH] = {DIRS.EAST},   [DIRS.EAST] = {DIRS.NORTH}, [DIRS.SOUTH] = {DIRS.WEST}, [DIRS.WEST] = {DIRS.SOUTH} },
    ["|"]  = { [DIRS.NORTH] = {DIRS.SOUTH}, [DIRS.SOUTH] = {DIRS.NORTH},  [DIRS.EAST] = { DIRS.NORTH, DIRS.SOUTH }, [DIRS.WEST] = { DIRS.NORTH, DIRS.SOUTH } },
    ["-"]  = {  [DIRS.EAST] = {DIRS.WEST},   [DIRS.WEST] = {DIRS.EAST},  [DIRS.NORTH] = { DIRS.EAST, DIRS.WEST },  [DIRS.SOUTH] = { DIRS.EAST, DIRS.WEST } }
}

function Travel(matrix, startRow, startCol, startTo)
    local energised = {}
    local pos = { { col = startCol, row = startRow, to = startTo } }
    local tiles = -1  -- -1 to account for the imaginary starting tile
    repeat
        local newpos = {}
        for _, p in ipairs(pos) do
            if not energised[p.row] or not energised[p.row][p.col] then
                tiles = tiles + 1
            end
            if not (energised[p.row] and energised[p.row][p.col] and energised[p.row][p.col][p.to]) then  -- Theoretically, one could additionally detect whether a way is trodden backwards but eh...
                energised[p.row] = energised[p.row] or {}
                energised[p.row][p.col] = energised[p.row][p.col] or {}
                energised[p.row][p.col][p.to] = true
                if p.to == DIRS.NORTH then  -- no switches in Lua :C
                    p.row = p.row - 1
                    p.to = (p.row > 0 and MIRRORS[matrix[p.row][p.col]][DIRS.SOUTH]) or {}
                elseif p.to == DIRS.SOUTH then
                    p.row = p.row + 1
                    p.to = (p.row <= #matrix and MIRRORS[matrix[p.row][p.col]][DIRS.NORTH]) or {}
                elseif p.to == DIRS.WEST then
                    p.col = p.col - 1
                    p.to = (p.col > 0 and MIRRORS[matrix[p.row][p.col]][DIRS.EAST]) or {}
                elseif p.to == DIRS.EAST then
                    p.col = p.col + 1
                    p.to = (p.col <= #matrix[1] and MIRRORS[matrix[p.row][p.col]][DIRS.WEST]) or {}
                end
                for _, dirs in ipairs(p.to) do
                    newpos[#newpos+1] = { row = p.row, col = p.col, to = dirs }
                end
            end
        end
        pos = newpos
    until #pos == 0
    return tiles
end

local matrix, _, _ = FileToMatrix()
local maxEnergised = 0
for r = 1, #matrix do
    maxEnergised = math.max(maxEnergised, Travel(matrix, r, 0, DIRS.EAST))  -- coming from the left edge
    maxEnergised = math.max(maxEnergised, Travel(matrix, r, #matrix[1]+1, DIRS.WEST))  -- coming from the right edge
end
for c = 1, #matrix[1] do
    maxEnergised = math.max(maxEnergised, Travel(matrix, 0, c, DIRS.SOUTH))  -- coming from the top edge
    maxEnergised = math.max(maxEnergised, Travel(matrix, #matrix+1, c, DIRS.NORTH))  -- coming from the bottom edge
end

print(("Es gibt %d energetisierte Kacheln."):format(Travel(matrix, 1, 0, DIRS.EAST)))
print(("Die Hoechstzahl waere %d."):format(maxEnergised))