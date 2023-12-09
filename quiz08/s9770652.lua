dofile "..\\quiz01\\s9770652_commons.lua"

local function Travel(startingNode, target, dirs, edges)
    local curr = startingNode
    local i = 0
    local step = 0
    while true do
        i = i + 1
        if i > #dirs then i = 1 end
        curr = edges[dirs[i]][curr]
        step = step + 1
        if curr:find(target) then
            return step
        end
    end
end

local lines = ReadAllLines()
local dirs = lines[1]:totable()
local edges = { L = {}, R = {} }
for i = 3, #lines do
    local node = lines[i]:sub(1, 3)
    edges.L[node] = lines[i]:sub(8, 10)
    edges.R[node] = lines[i]:sub(13, 15)
end

local totalSteps = 1
for node, _ in pairs(edges.L) do
    if node:sub(3, 3) == "A" then
        totalSteps = lcm(Travel(node, "%w%wZ", dirs, edges), totalSteps)
    end
end

print(("%d Schritte sind noetig, startet man nur bei AAA."):format(Travel("AAA", "ZZZ", dirs, edges)))  -- solution of first part
print(("%d Schritte sind noetig, startet man bei allen mit A endenden Knoten."):format(totalSteps))  -- solution of second part