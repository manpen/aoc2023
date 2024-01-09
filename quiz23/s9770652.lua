dofile "..\\quiz01\\s9770652_commons.lua"

local DIRS = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }
local SYM = Enum{ ">", "v", "<", "^" }  -- Their order must correspond to `DIRS`.

local function withinBounds(r, c, rows, cols)
    return 1 <= r and r <= rows and 1 <= c and c <= cols
end

-- Returns the ID of a node if it is at `coords`, else `nil`.
local function isNode(V, coords)
    for ni, node in ipairs(V) do
        if node[1] == coords[1] and node[2] == coords[2] then
            return ni
        end
    end
end

-- All non-blocked tiles which have more than two neighbours shall be nodes.
-- All others are dead ends or tunnels.
local function getNodes(matrix, rows, cols)
    local V = { { 1, 2 } }
    for r = 1, rows do
        for c = 1, cols do
            local neighs = 0
            for _, dir in ipairs(DIRS) do
                local rr, cc = r + dir[1], c + dir[2]
                if withinBounds(rr, cc, rows, cols) and matrix[rr][cc] ~= "#" then
                    neighs = neighs + 1
                end
            end
            if neighs > 2 and matrix[r][c] ~= "#" then
                V[#V+1] = { r, c }
            end
        end
    end
    V[#V+1] = { rows, cols - 1 }
    return V
end

-- Counts how many tunnels are between any two nodes.
-- Their number is the weight of the edge between those two nodes.
local function getEdges(matrix, V, rows, cols, slopes)
    local E = {}; for vi = 1, #V do E[vi] = {} end
    for vi, v in ipairs(V) do
        local seen = Cache2D:new()  -- tile visited in this round?
        local queue = { {v[1], v[2], 0} }
        repeat
            local r, c, dist = queue[1][1], queue[1][2], queue[1][3]
            table.remove(queue, 1)
            if not seen:getCached(r, c) then
                seen:cache(true, r, c)
                local ni = isNode(V, {r, c})
                if (r ~= v[1] or c ~= v[2]) and ni then  -- Node reached that is not `vi`?
                    E[vi][#E[vi]+1] = { ni, dist }
                else
                    for i = 1, 4 do  -- Check all four possible neighbours.
                        local dr, dc = DIRS[i][1], DIRS[i][2]
                        local rr, cc = r + dr, c + dc
                        if withinBounds(rr, cc, rows, cols) and matrix[rr][cc] ~= "#" then
                            -- If slopes are active and a slope is encountered,
                            -- only move if the direction is legal.
                            if not (slopes and SYM[matrix[r][c]] and SYM[matrix[r][c]] ~= i) then
                                table.insert(queue, { rr, cc, dist+1 })
                            end
                        end
                    end
                end
            end
        until #queue == 0
    end
    return E
end

-- A recursive depth-first search.
-- Yes, even for part 2 I just brute-force through every possible path.
local function findLongestPath(E)
    local maxLength = 0
    local seen = {}
    local function dfs(vi, dist)
        if seen[vi] then return end
        if vi == #E then
            maxLength = math.max(maxLength, dist)
            return
        end
        seen[vi] = true
        for _, v in ipairs(E[vi]) do
            dfs(v[1], v[2]+dist)
        end
        seen[vi] = false
    end
    dfs(1, 0)
    return maxLength
end

local matrix, rows, cols = FileToMatrix()
local V = getNodes(matrix, rows, cols)
local E = getEdges(matrix, V, rows, cols, true)
print(("Der laengste Weg mit Schlittereinlagen ist %d LE lang."):format(findLongestPath(E)))  -- solution of first part
E = getEdges(matrix, V, rows, cols, false)
print(("Der laengste Weg ohne Schlittereinlagen ist %d LE lang."):format(findLongestPath(E)))  -- solution of second part