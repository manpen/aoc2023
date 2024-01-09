dofile "..\\quiz01\\s9770652_commons.lua"

-- This is an implementation of Karger's algorithm.
-- Initially, each vertex is in its own vertex set.
-- Then, an edge is repeatedly selected and the vertex sets of both incident vertices merged
-- until there are only two vertex sets left.
local function minCut(size, edges)
    local union = UFDS:new()  -- union-find data structure for the vertices
    union:setSize(size)
    -- Repeatedly merge vertex sets.
    while size > 2 do
        local e = edges[math.random(#edges)]
        local set1, set2 = union:find(e[1]), union:find(e[2])
        if set1 ~= set2 then
            size = size - 1
            union:union(e[1], e[2])
        end
    end
    -- Count the edges crossing both vertex sets.
    local crossing = 0
    for _, e in ipairs(edges) do
        crossing = crossing + ((union:find(e[1]) ~= union:find(e[2]) and 1) or 0)
    end
    -- Determine the size of the first vertex set.
    local set1, set1Size = union:find(1), 0
    for i = 1, union.size do
        set1Size = set1Size + ((union:find(i) == set1 and 1) or 0)
    end
    return crossing, set1Size, union.size - set1Size
end

local lines = ReadAllLines()
local V, E = {}, {}  -- `V` is used to turn the names into IDs. `E` is an edge list.
local size = 0
for _, line in ipairs(lines) do
    local node = line:sub(1, 3)
    if node == "" then break end  -- For some reason, my (all?) input files have many empty lines at the bottom.
    if not V[node] then
        size = size + 1
        V[node] = size
    end
    for _, neigh in ipairs(line:sub(4):totable("%w+")) do
        if not V[neigh] then
            size = size + 1
            V[neigh] = size
        end
        E[#E+1] = { V[node], V[neigh] }
    end
end
local crossing, set1Size, set2Size
repeat
    crossing, set1Size, set2Size = minCut(size, E)
until crossing == 3
print(("Das Produkt der Gruppengroeszen betraegt %d."):format(set1Size * set2Size))  -- solution of first part
print("Frohe Weihnachten!")  -- solution of second part