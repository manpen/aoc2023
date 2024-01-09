dofile "..\\quiz01\\s9770652_commons.lua"

local DIRS = Enum{"SOUTH", "NORTH", "WEST", "EAST"}
local PIPES = {
    ["|"] = { [DIRS.NORTH] = DIRS.SOUTH, [DIRS.SOUTH] = DIRS.NORTH },
    ["-"] = { [DIRS.EAST] = DIRS.WEST, [DIRS.WEST] = DIRS.EAST },
    ["L"] = { [DIRS.NORTH] = DIRS.EAST, [DIRS.EAST] = DIRS.NORTH },
    ["J"] = { [DIRS.NORTH] = DIRS.WEST, [DIRS.WEST] = DIRS.NORTH },
    ["7"] = { [DIRS.SOUTH] = DIRS.WEST, [DIRS.WEST] = DIRS.SOUTH },
    ["F"] = { [DIRS.SOUTH] = DIRS.EAST, [DIRS.EAST] = DIRS.SOUTH },
}

-- Mark visited pipes as (significant) vertical delimiers or not.
-- Do not turn 'L' into a delimiter. After it, '-' may follow.
-- If a '7' follows, the '7' is turned into a delimiter.
-- If a 'J' follows, the tiles after 'J' are still within the loop.
-- The same logic applies to 'L'.
function MarkPipe(pipe)
    if pipe == "|" or pipe == "7" or pipe == "F" then
        return "!"
    else
        return "?"
    end
end

function Travel(matrix, startCol, startRow)
    local steps = 0
    local S = matrix[startRow][startCol]
    local to = PIPES[S][1] or PIPES[S][2] or PIPES[S][3]
    local i = { col = startCol, row = startRow }
    -- Travel through the matrix and mark visited pipes.
    repeat
        steps = steps + 1
        if to == DIRS.NORTH then  -- no switches in Lua :C
            i.row = i.row - 1
            to = PIPES[matrix[i.row][i.col]][DIRS.SOUTH]
        elseif to == DIRS.SOUTH then
            i.row = i.row + 1
            to = PIPES[matrix[i.row][i.col]][DIRS.NORTH]
        elseif to == DIRS.WEST then
            i.col = i.col - 1
            to = PIPES[matrix[i.row][i.col]][DIRS.EAST]
        elseif to == DIRS.EAST then
            i.col = i.col + 1
            to = PIPES[matrix[i.row][i.col]][DIRS.WEST]
        end
        assert(to ~= nil)  -- Abortion if starting pipe was not set to correct pipe tile.
        matrix[i.row][i.col] = MarkPipe(matrix[i.row][i.col])
    until i.col == startCol and i.row == startRow
    -- Scan the matrix and count unvisited pipes within delimiters.
    local enclosed = 0
    local within
    for row = 1, #matrix do
        within = false
        for col = 1, #matrix[row] do
            if matrix[row][col] == "!" then
                within = not within  -- True if an odd number of delimiters is to the left.
            elseif matrix[row][col] ~= "?" and within then
                enclosed = enclosed + 1
            end
        end
    end
    return steps, enclosed
end

local lines = FileToMatrix()
local startCol, startRow
for row = 1, #lines do
    for col = 1, #lines[row] do
        if lines[row][col] == "S" then
            startCol = col
            startRow = row
            break
        end
    end
end

-- Try any possible pipe for the starting pipe.
for pipe, _ in pairs(PIPES) do
    local matrix = deepcopy(lines)  -- Copy matrix to freely mark tiles. Time and memory are worthless.
    matrix[startRow][startCol] = pipe  -- Change out 'S' with a pipe.
    local correctPipe, steps, enclosed = pcall(Travel, matrix, startCol, startRow)
    if correctPipe then  -- true when `pipe` works as starting pipe
        print(("Die groesste Entfernung betraegt %d."):format(steps / 2))  -- solution of first part
        print(("Es werden %d Felder eingeschlossen."):format(enclosed))  -- solution of second part
        break
    end
end