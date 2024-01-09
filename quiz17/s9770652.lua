dofile "..\\quiz01\\s9770652_commons.lua"
local minheap = dofile "..\\quiz01\\s9770652_minheap.lua"

local DIRS = { { 0, 1 }, { 0, -1 }, { 1, 0 }, { -1, 0 } }  -- left, right, up, down
local TURNS = { { 3, 4 }, { 3, 4 }, { 1, 2 }, { 1, 2 }, [-1] = { 1, 2, 3, 4 } }  -- in which directions the crucible can turn

-- Hoa, Pyramide des Untergangs ahoi!
-- This is a modified version of Dijkstra's algorithm.
-- A 3D graph is traversed by quadrupling each field,
-- so there is one node for each direction from which the field was accessed.
local function Travel(matrix, rows, cols, min, max)
    local seen, heats = Cache3D:new(), Cache3D:new()
    local q = minheap.new()
    q:push(0, { 1, 1, -1 })  -- heat: row, column, whence
    repeat
        local p = q:pop()
        local h, r, c, w = p.pri, table.unpack(p.val)
        if r == rows and c == cols then
            return h
        end
        if not seen:getCached(r, c, w) then
            seen:cache(1, r, c, w)
            for _, dir in ipairs(TURNS[w]) do
                local hh, rr, cc = h, r, c
                for dist = 1, max do  -- Move in a straight line. At each tile, add a turn to the queue.
                    rr, cc = rr + DIRS[dir][1], cc + DIRS[dir][2]
                    if (rr < 1 or rr > rows or cc < 1 or cc > cols) then break end  -- borders reached -> stop
                    hh = hh + matrix[rr][cc]
                    if dist >= min then  -- not wihthin the loop head so that `hh` is increased correctly
                        if (heats:getCached(rr, cc, dir) or math.huge) > hh then
                            heats:cache(hh, rr, cc, dir)
                            q:push(hh, { rr, cc, dir })
                        end
                    end
                end
            end
        end
    until q:isEmpty()  -- should never be necessary
    return -1
end

local matrix, rows, cols = FileToMatrix(nil, nil, tonumber)
print(("Der Schmelztiegel verliert %d HE."):format(Travel(matrix, rows, cols, 1, 3)))
print(("Der Ueberschmelztiegel verliert %d HE."):format(Travel(matrix, rows, cols, 4, 10)))