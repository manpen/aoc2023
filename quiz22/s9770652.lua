dofile "..\\quiz01\\s9770652_commons.lua"

-- My very first generator in Lua. \o/
-- It thrashes performance, though. :C
local function coords(brick)
    local x, y, z = brick[1][1], brick[1][2], brick[1][3] - 1
    return function ()
        z = z + 1
        if z > brick[2][3] then
            y = y + 1
            z = brick[1][3]
        end
        if y > brick[2][2] then
            x = x + 1
            y = brick[1][2]
        end
        if x <= brick[2][1] then
            return x, y, z
        end
    end
end

-- Due to the generator's poor performance,
-- I wrote this iterator instead.
local function applyOnCoords(brick, fn)
    for x = brick[1][1], brick[2][1] do
        for y = brick[1][2], brick[2][2] do
            for z = brick[1][3], brick[2][3] do
                fn(x, y, z)
            end
        end
    end
end

local lines = ReadAllLines()
local bricks = {}
for _, line in ipairs(lines) do
    local brick = line:split("~")
    bricks[#bricks+1] = {
        brick[1]:split(",", tonumber),
        brick[2]:split(",", tonumber),
        above = {},
        below = {},
    }
end
table.sort(bricks, function (a, b) return a[1][3] < b[1][3] end)  -- lower bricks first

-- Each coordinate where a brick is resting, contains the ID of the corresponding brick.
local occupied = Cache3D:new()
for b, brick in ipairs(bricks) do
    while brick[1][3] > 1 do  -- Z-value must be above ground.
        local stopped = false
        brick[1][3], brick[2][3] = brick[1][3] - 1, brick[2][3] - 1  -- Let brick fall one unit down.
        -- for x, y, z in coords(brick) do
        --     local occupiedBy = occupied:getCached(x, y, z)
        --     if occupiedBy then
        --         stopped = true
        --         if bricks[occupiedBy].above[#bricks[occupiedBy].above] ~= b then
        --             bricks[occupiedBy].above[#bricks[occupiedBy].above+1] = b
        --             brick.below[#brick.below+1] = occupiedBy
        --         end
        --     end
        -- end
        applyOnCoords(brick, function (x, y, z)
            local occupiedBy = occupied:getCached(x, y, z)
            if occupiedBy then
                stopped = true
                if bricks[occupiedBy].above[#bricks[occupiedBy].above] ~= b then
                    bricks[occupiedBy].above[#bricks[occupiedBy].above+1] = b
                    brick.below[#brick.below+1] = occupiedBy
                end
            end
        end)
        if stopped then  -- If stopped by other brick, then elevate the brick again.
            brick[1][3], brick[2][3] = brick[1][3] + 1, brick[2][3] + 1
            break
        end
    end
    -- for x, y, z in coords(brick) do
    --     occupied:cache(b, x, y, z)
    -- end
    applyOnCoords(brick, function (x, y, z)
        occupied:cache(b, x, y, z)
    end)
end

-- For each resting brick, check for any brick above if all bricks below it are falling.
-- If yes, it falls, too.
local safe, chain = 0, 0
for b, brick in ipairs(bricks) do
    local isFalling = { [b] = true }  -- all bricks which definitely fall
    local falling = 0  -- number of falling bricks (not countign the first one)
    local toCheck = brick.above  -- queue of all bricks which had bricks below them fall
    while #toCheck > 0 do
        local nextToCheck = {}
        for _, above in ipairs(toCheck) do
            local isfalling = true
            for _, below in ipairs(bricks[above].below) do
                if not isFalling[below] then
                    isfalling = false
                    break
                end
            end
            if isfalling and not isFalling[above] then
                isFalling[above] = true
                falling = falling + 1
                for _, a in ipairs(bricks[above].above) do
                    nextToCheck[#nextToCheck+1] = a
                end
            end
        end
        toCheck = nextToCheck
    end
    safe = safe + ((falling == 0 and 1) or 0)  -- incremented if no other blocks falls
    chain = chain + falling
end
print(("Es koennen %d Bloecke sicher entfernt werden."):format(safe))  -- solution of first part
print(("Es werden %d Bloecke herunterfallen."):format(chain))  -- solution of second part