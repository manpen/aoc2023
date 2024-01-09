dofile "..\\quiz01\\s9770652_commons.lua"

-- Visits each spring in `springs`.
---@param springs table All springs as array.
---@param dmgd table Array of sizes of all blocks of damaged springs.
---@param si number Index of current spring.
---@param di number Index of current damaged block.
---@param dLength number Length of traversed part of current damaged block.
---@param cache Cache3D
function GetArrangementCount(springs, dmgd, si, di, dLength, cache)
    local cached = cache:getCached(si, di, dLength)
    if cached then return cached end
    if si == #springs then  -- Due to padding, the last spring is always ".".
        return (di == #dmgd and dLength == 0 and 1) or 0  -- Check if all damaged blocks have been closed.
    end
    local ac = 0
    if springs[si+1] == "." or springs[si+1] == "?" then
        if dLength == 0 then  -- No damaged block to close; previous spring "." or "?".
            ac = ac + GetArrangementCount(springs, dmgd, si+1, di, 0, cache)
        elseif dLength > 0 and di < #dmgd and dmgd[di+1] == dLength then  -- Close damaged block.
            ac = ac + GetArrangementCount(springs, dmgd, si+1, di+1, 0, cache)
        end
    end
    if springs[si+1] == "#" or springs[si+1] == "?" then  -- Continue current damaged block.
        ac = ac + GetArrangementCount(springs, dmgd, si+1, di, dLength+1, cache)
    end
    cache:cache(ac, si, di, dLength)
    return ac
end

local lines = ReadAllLines()
for _, reps in ipairs({1, 5}) do
    local springs, dmgd = {}, {}
    for k, line in ipairs(lines) do
        local l = line:split()
        springs[k] = (l[1]:rep(reps, "?").."."):totable(".")  -- Add final "." as padding.
        dmgd[k] = (l[2]:rep(reps, ",").."."):totable("%d+", tonumber)
    end
    local sum = 0
    for i = 1, #springs do
        sum = sum + GetArrangementCount(springs[i], dmgd[i], 0, 0, 0, Cache3D:new())
    end
    print(("Mit %d-facher Faltung betraegt die Anzahl an moeglichen Kombination %d."):format(reps, sum))  -- solution of both parts
end