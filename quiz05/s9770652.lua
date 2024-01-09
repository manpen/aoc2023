dofile "..\\quiz01\\s9770652_commons.lua"

-- Returns an array of pairs which indicate the first and last values of the seed ranges.
-- Set `ranges` to true to generate the ranges according to the second part of the quiz.
function GetSeeds(firstLine, ranges)
    local rawSeeds = {}
    for s in firstLine:gmatch("%d+") do
        rawSeeds[#rawSeeds+1] = tonumber(s)
    end
    local seeds = {}
    if ranges then  -- Second part: Pairs of numbers define a range.
        for s = 1, #rawSeeds-1, 2 do
            seeds[#seeds+1] = { rawSeeds[s], rawSeeds[s]+rawSeeds[s+1]-1 }
        end
    else  -- First part: Each number is a range of length 1.
        for s = 1, #rawSeeds do
            seeds[#seeds+1] = { rawSeeds[s], rawSeeds[s] }
        end
    end
    return seeds
end

-- Returns an array of arrays for each rule type, containing `{ source, offset }` for each rule.
-- The rules cover the entire range of possible source values through padding rules.
-- The rules are sorted ascendingly by their `source` value.
function GetRules(lines)
    local rules = {}
    -- Read lines and calculate "true" rules where the numbers are offset.
    for i = 3, #lines do
        if lines[i] ~= "" then
            if lines[i]:find("map") then
                rules[#rules+1] = {}
            else
                local dest, source, length = lines[i]:match("(%d+) (%d+) (%d+)")
                table.insert(rules[#rules], {
                    source = tonumber(source),
                    length = tonumber(length),  -- will be deleted at the end of the function
                    offset = tonumber(dest) - tonumber(source)
                })
            end
        end
    end
    -- Add "padding" rules where the numbers stay the same.
    for _, rule in ipairs(rules) do
        table.sort(rule, function (a, b) return a.source < b.source end)
        table.insert(rule, 1, {  -- Add rule for any number before the first true rule.
            source = -math.huge,
            offset = 0
        })
        table.insert(rule, {  -- Add rule for any number after the last true rule.
            source = rule[#rule].source + rule[#rule].length,
            offset = 0
        })
        for r = #rule-1, 3, -1 do  -- Add rule for any number between two true rules.
            if rule[r].source > rule[r-1].source + rule[r-1].length then
                table.insert(rule, r, {
                    source = rule[r-1].source + rule[r-1].length,
                    offset = 0
                })
            end
            rule[r].length = nil
        end
    end
    return rules
end

-- Returns the smallest location number.
function GetSmallestLocation(rules, seeds)
    local min = math.huge
    for s = 1, #seeds do  -- Analyse each initial seed range indiviually.
        local ranges = { start = {seeds[s][1]}, ending = {seeds[s][2]} }
        for _, ruleType in ipairs(rules) do  -- Apply rule categories sequentially.
            local newRanges = { start = {}, ending = {} }
            for i = 1, #ranges.start do  -- Analyse current number ranges in arbitrary order.
                for j, rule in ipairs(ruleType) do  -- Apply rules sequentially.
                    local nextRule = ruleType[j+1] or { source = math.huge }
                    if rule.source <= ranges.ending[i] and ranges.start[i] <= nextRule.source-1 then
                        local start = math.max(rule.source, ranges.start[i])
                        local ending = math.min(nextRule.source-1, ranges.ending[i])
                        newRanges.start[#newRanges.start+1] = start + rule.offset
                        newRanges.ending[#newRanges.ending+1] = ending + rule.offset
                    end
                end
            end
            ranges = newRanges
        end
        min = math.min(min, table.unpack(ranges.start))
    end
    return min
end

local lines = ReadAllLines()
local rules = GetRules(lines)

local seeds = GetSeeds(lines[1])
local min = GetSmallestLocation(rules, seeds)
print(("Die kleinste Ortszahl bei einfachen Zahlen ist %d."):format(min))  -- solution of first part

seeds = GetSeeds(lines[1], true)
min = GetSmallestLocation(rules, seeds)
print(("Die kleinste Ortszahl bei Wertebereichen ist %d."):format(min))  -- solution of second part