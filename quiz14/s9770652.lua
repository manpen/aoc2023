dofile "..\\quiz01\\s9770652_commons.lua"

-- `caches` is an array of all matrices seen so far.
-- If `matrix` is cached, then the round in which it was seen is returned.
local function GetCycleStart(caches, matrix)
    local cycleStart = -1
    for ci, cache in ipairs(caches) do
        if CompareMatrices(matrix, cache) then
            cycleStart = ci
            break
        end
    end
    return cycleStart - 1  -- Zero-based is better in the following calculations.
end

local function GetLoad(matrix)
    local load = 0
    for ri, row in ipairs(matrix) do
        for _, rock in ipairs(row) do
            if rock == "O" then
                load = load + (#matrix - (ri-1))
            end
        end
    end
    return load
end

local matrix, rows, cols = FileToMatrix()
local caches = {}
local firstLoad, finalLoad  -- solution of first and second part
local reps, rep = 1000000000, 0  -- (max.) number of repetitions (called 'cycles' in the exercise)
while true do
    rep = rep + 1
    local cycleStart = GetCycleStart(caches, matrix)  -- the first time `matrix` has been seen
    if cycleStart >= 0 then  -- non-negative if matrix already seen -> cycle completed
        local cycleLength = (rep-1) - cycleStart  -- length of completed cycle
        local repsWithoutUnique = reps - cycleStart  -- Some of the first matrices may not have been part of any cycle.
        local endWithinFinalCycle = repsWithoutUnique % cycleLength  -- How long is the final, potentially unfinished cycle?
        finalLoad = GetLoad(caches[ cycleStart + endWithinFinalCycle + 1 ])
        break
    end
    caches[rep] = deepcopy(matrix)
    -- North tilt.
    for c = 1, cols do
        local lastFree = (matrix[1][c] == "." and 1) or 2
        for r = 2, rows do
            if matrix[r][c] == "O" then
                matrix[r][c] = "."
                matrix[lastFree][c] = "O"
                lastFree = lastFree + 1
            elseif matrix[r][c] == "#" then
                lastFree = r + 1
            end
        end
    end
    if rep == 1 then firstLoad = GetLoad(matrix) end
    -- West tilt.
    for r = 1, rows do
        local lastFree = (matrix[r][1] == "." and 1) or 2
        for c = 2, cols do
            if matrix[r][c] == "O" then
                matrix[r][c] = "."
                matrix[r][lastFree] = "O"
                lastFree = lastFree + 1
            elseif matrix[r][c] == "#" then
                lastFree = c + 1
            end
        end
    end
    -- South tilt.
    for c = 1, cols do
        local lastFree = (matrix[rows][c] == "." and rows) or (cols - 1)
        for r = rows-1, 1, -1 do
            if matrix[r][c] == "O" then
                matrix[r][c] = "."
                matrix[lastFree][c] = "O"
                lastFree = lastFree - 1
            elseif matrix[r][c] == "#" then
                lastFree = r - 1
            end
        end
    end
    -- East tilt.
    for r = 1, rows do
        local lastFree = (matrix[r][cols] == "." and cols) or (cols-1)
        for c = cols-1, 1, -1 do
            if matrix[r][c] == "O" then
                matrix[r][c] = "."
                matrix[r][lastFree] = "O"
                lastFree = lastFree - 1
            elseif matrix[r][c] == "#" then
                lastFree = c - 1
            end
        end
    end
end

print(("Die Belastung nach einer Kippung betreagt %d."):format(firstLoad))  -- solution of first part
print(("Die Belastung nach %d Kippungen betreagt %d."):format(reps, finalLoad))  -- solution of second part