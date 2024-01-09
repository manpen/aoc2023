dofile "..\\quiz01\\s9770652_commons.lua"

local MIN, MAX = 200000000000000, 400000000000000

-- Calculate the intersection of two given hails in the XY-plain if present.
-- Can return NaN because of divison-by-zero, but I will just ignore that because who cares?
---@return number|nil x
---@return number|nil y
---@return number|nil r How often the movement vector of hail `a` has to be multiplied to reach the intersection.
---@return number|nil s How often the movement vector of hail `b` has to be multiplied to reach the intersection.
local function intersectionXY(a, b)
    if not ((a.v.y == 0 and b.v.y == 0) or ((a.v.y ~= 0 and b.v.y ~= 0 and (a.p.x/b.p.x == b.p.x/b.p.y)))) then
        local r = ( a.p.x*b.v.y - a.p.y*b.v.x + b.p.y*b.v.x - b.p.x*b.v.y ) / (a.v.y*b.v.x - a.v.x*b.v.y)
        local s = ( a.p.x - b.p.x + r * a.v.x ) / b.v.x
        local x, y = a.p.x + r * a.v.x,  a.p.y + r * a.v.y
        return x, y, r, s
    end
end

local hails = {}
for i, line in ipairs(ReadAllLines()) do
    local h = line:totable("-?%d+", tonumber)
    hails[i] = { p = { x = h[1], y = h[2], z = h[3] }, v = { x = h[4], y = h[5], z = h[6] } }
end

-- Simply go through each pair of hails and check
-- if they intersect within the wanted range.
local count = 0
for i = 1, #hails-1 do
    for j = i+1, #hails do
        local x, y, r, s = intersectionXY(hails[i], hails[j])
        if MIN <= x and x <= MAX and MIN <= y and y <= MAX and r > 0 and s > 0 then
            count = count + 1
        end
    end
end
print(("Es gibt %d Ueberschneidungen."):format(count))  -- solution of first part

-- Instead of a moving rock, use a resting one and subtract its movement vector
-- from the movement vectors of all hails. The hails, then, all intersect in the same point.
-- So, check every possible triple (x, y, z) with x, y, z = -R..R as possible rock position.
-- First, check every pair (x, y) and check z only if x and y are plausible.
local rock, coordsFound = {}, false
local R = 250
for x = -R, R do
    for y = -R, R do
        local hail = { p = hails[1].p, v = { x = hails[1].v.x - x, y = hails[1].v.y - y } }
        -- If (x, y) is plausible, then it must be the intersection (`px`, `py`) of the first two hails.
        local px, py, pr, _ = intersectionXY(
            hail,
            { p = hails[2].p, v = { x = hails[2].v.x - x, y = hails[2].v.y - y } }
        )
        if px then
            local plausibleXY = true
            for i = 3, #hails do  -- Check if all other hails pass (x, y).
                local ix, iy, _, _ = intersectionXY(
                    hail,
                    { p = hails[i].p, v = { x = hails[i].v.x - x, y = hails[i].v.y - y } }
                )
                if ix ~= px or iy ~= py then
                    plausibleXY = false
                    break
                end
            end
            -- If each hail passes (x, y), then go through every value for z.
            if plausibleXY then
                for z = -R, R do
                    local plausibleZ = true
                    local pz = hail.p.z + pr * (hails[1].v.z - z)  -- `pz` is the z value to `px` and `py`.
                    for i = 2, #hails do
                        -- `intersectionXY` might have returned NaN.
                        -- Like a true mathematician, I just skip this case as it works anyway.
                        local coeff = (px - hails[i].p.x) / (hails[i].v.x - x)
                        if not (tostring(coeff) == tostring(0/0)) then
                            if hails[i].p.z + coeff * (hails[i].v.z - z) ~= pz then
                                plausibleZ = false
                                break
                            end
                        end
                    end
                    -- A possible rock location was found.
                    -- Since there is exactly one, the loops can be stopped.
                    if plausibleZ then
                        rock = { px, py, pz }
                        coordsFound = true
                        break
                    end
                end
            end
        end
        if coordsFound then break end
    end
    if coordsFound then break end
end
print(("Die Summe der Koordinaten des Steines ist %d."):format(table.sum(rock)))  -- solution of second part