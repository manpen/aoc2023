dofile "..\\quiz01\\s9770652_commons.lua"

local MOVES = { L = { -1, 0 }, R = { 1, 0 }, D = { 0, 1 }, U = { 0, -1 } }
local NUM2DIR = { ["0"] = "R", ["1"] = "D", ["2"] = "L", ["3"] = "U" }

-- Returns a list of all points saved in one direction ((counter-)clockwise)
-- and the perimeter of the polygon.
local function createPolygon(plan)
    local poly, perimeter = {}, 0
    local pos = { 0, 0 }
    for i, line in ipairs(plan) do
        local x, y = table.unpack(MOVES[line[1]])
        perimeter = perimeter + line[2]
        pos[1] = pos[1] + x * line[2]
        pos[2] = pos[2] + y * line[2]
        poly[i] = { pos[1], pos[2] }
    end
    return poly, perimeter
end

-- Calculates the inner area (A) using Gauss's area formula.
-- If applied on points saved clockwise, the calculated area is negative, hence `math.abs`.
-- Then, Pick's theorem is used to calculate the total area:
-- A = I + R/2 - 1  ->  I + R = A + R/2 + 1,
-- where I is the number of grid points within the boundary
-- and R is the number of grid points on the boundary (in this case equal to the perimeter).
local function calculateArea(poly, perimeter)
    local area = 0
    for i = 1, #poly do
        local j = i + 1
        if j > #poly then j = 1 end
        local x1, y1 = poly[i][1], poly[i][2]
        local x2, y2 = poly[j][1], poly[j][2]
        area = area + (y1 + y2) * (x1 - x2)  -- Iteratively apply Gauss's area formula.
    end
    return math.abs(area) / 2 + perimeter / 2 + 1  -- Apply Pick's theorem. 
end

local lines = ReadAllLines()
for i = 1, #lines do
    lines[i] = lines[i]:split()
end
local poly, perimeter = createPolygon(lines)
print(("Das Volumen betraegt %d kl bei den normalen Angaben."):format(calculateArea(poly, perimeter)))  -- solution of first part

for i = 1, #lines do
    local dir = NUM2DIR[lines[i][3]:sub(-2, -2)]  -- extracts last digit (ere-last character)
    lines[i] = { dir, tonumber("0x"..lines[i][3]:sub(3, 7)) }
end
poly, perimeter = createPolygon(lines)
print(("Das Volumen betraegt %d kl bei der hexadezimalen Angabe."):format(calculateArea(poly, perimeter)))  -- solution of second part