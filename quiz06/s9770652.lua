function GetProductOfCombinations(times, dists)
    local prod = 1
    for i = 1, #times do
        -- essentially using the p-q formula to solve t*(times[i]-t) > dists[i]
        local t = math.floor(times[i]/2 - math.sqrt((-times[i]/2)^2 - dists[i]) + 1)
        prod = prod  * (times[i] - t*2 + 1)
    end
    return prod
end

local file = assert(io.open("s9770652.txt", "r"))
local times = {}
for time in file:read("*l"):gmatch("%d+") do
   times[#times+1] = tonumber(time)
end
local dists = {}
for dist in file:read("*l"):gmatch("%d+") do
    dists[#dists+1] = tonumber(dist)
end

print(("Die erste Antwort lautet %d."):format(GetProductOfCombinations(times, dists)))  -- solution of first part
print(("Die zweite Antwort lautet %d."):format(  -- solution of second part
    GetProductOfCombinations({tonumber(table.concat(times))}, {tonumber(table.concat(dists))})
))