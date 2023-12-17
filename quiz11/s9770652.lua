dofile "..\\quiz01\\s9770652_commons.lua"

function AnalyseUniverse(matrix)
    local empty = { rows = {}, cols = {} }
    local galaxies = {}
    -- Check for empty rows.
    for row = #matrix, 1, -1 do
        for col = 1, #matrix[row] do
            if matrix[row][col] == "#" then
                empty.rows[row] = true  -- hacky: soon to be flipped
                galaxies[#galaxies+1] = { row, col }
            end
        end
        empty.rows[row] = not (empty.rows[row] or false)
    end
    -- Check for empty columns.
    for col = #matrix[1], 1, -1 do
        for row = 1, #matrix do
            if matrix[row][col] == "#" then
                empty.cols[col] = true  -- hacky: soon to be flipped
                break
            end
        end
        empty.cols[col] = not (empty.cols[col] or false)
    end
    return galaxies, empty
end

function ComputeDistances(galaxies, empty, fill)
    local dists = 0
    for i = 1, #galaxies-1 do
        for j = i+1, #galaxies do
            local g1, g2 = galaxies[i], galaxies[j]
            for row = math.min(g1[1], g2[1]), math.max(g1[1], g2[1]) - 1 do
                dists = dists + ((empty.rows[row] and fill) or 1)
            end
            for col = math.min(g1[2], g2[2]), math.max(g1[2], g2[2]) - 1 do
                dists = dists + ((empty.cols[col] and fill) or 1)
            end
        end
    end
    return dists
end

local matrix = FileToMatrix()
local galaxies, empty = AnalyseUniverse(matrix)

print(("Bei seichter Ausdehnung betraegt die Summe der Entfernungen %d."):format(  -- solution of first part
    ComputeDistances(galaxies, empty, 2)
))
print(("Bei starker Ausdehnung betraegt die Summe der Entfernungen %d."):format(  -- solution of second part
    ComputeDistances(galaxies, empty, 1000000)
))