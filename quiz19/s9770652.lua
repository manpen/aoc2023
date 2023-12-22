dofile "..\\quiz01\\s9770652_commons.lua"

-- Just for fun and even more speed: A custom table copier.
local function fastRangeCopy(range)
    return {
        x = { range.x[1], range.x[2] },
        m = { range.m[1], range.m[2] },
        a = { range.a[1], range.a[2] },
        s = { range.s[1], range.s[2] },
    }
end

-- Each table in `ranges` contains an inclusive range for each rating.
-- Whenever a rule is applied, a new range is created where the respective rating is bounded accordingly
-- and all other ratings stay the same.
---@param workflows table
---@param ranges? table In the first quiz, the parts are provided as ranges of length.
---@param single? boolean Whether the ranges are actually ranges or just the parts from the first quiz.
local function GetAcceptedRanges(workflows, ranges, single)
    workflows.R, workflows.A = {{}}, {{}}  -- Empty rules during which the current range will be added to `accepted` or not.
    ranges = ranges or { {fate = "in", x = {1, 4000}, m = {1, 4000}, a = {1, 4000 }, s = {1, 4000}} }  -- `fate` is the next rule to be applied.
    local accepted = {}
    repeat
        local newranges = {}
        for _, range in ipairs(ranges) do
            for _, rule in ipairs(workflows[range.fate]) do
                if range.fate == "A" then
                    accepted[#accepted+1] = range
                    break
                elseif rule[2] == "<" then
                    if range[rule[1]][1] < rule[3] then
                        local nr = fastRangeCopy(range)  -- Create new range.
                        nr.fate = rule[4]  -- Set its target rule.
                        nr[rule[1]] = { range[rule[1]][1], math.min(range[rule[1]][2], rule[3]-1) }  -- Bound its rating.
                        newranges[#newranges+1] = nr
                        if single then break end  -- Create no new range if the range is actually just a part from the first quiz.
                        range[rule[1]][1] = math.min(range[rule[1]][2], rule[3]-1) + 1  -- Bound the rating of the original range.
                    end
                elseif rule[2] == ">" then
                    if range[rule[1]][2] > rule[3] then
                        local nr = fastRangeCopy(range)  -- Create new range.
                        nr.fate = rule[4]  -- Set its target rule.
                        nr[rule[1]] = { math.max(range[rule[1]][1], rule[3]+1), range[rule[1]][2] }  -- Bound its rating.
                        newranges[#newranges+1] = nr
                        if single then break end  -- Create no new range if the range is actually just a part from the first quiz.
                        range[rule[1]][2] = math.max(range[rule[1]][1], rule[3]+1) - 1  -- Bound the rating of the original range.
                    end
                elseif not (range.fate == "R") then
                    range.fate = rule[1]
                    newranges[#newranges+1] = range
                end
            end
        end
        ranges = newranges
    until #ranges == 0
    return accepted
end

local lines = ReadAllLines()

local workflow = {}
local startOfParts = 0
for i = 1, #lines do
    local name = lines[i]:match"(.*){"
    if name == nil then startOfParts = i break end
    workflow[name] = lines[i]:match"{(.*)}":split(",")
    for ri, rule in ipairs(workflow[name]) do
        local pos = rule:find("[<>]")
        if pos then  -- A comparator was found.
            local s = rule:find(":")
            workflow[name][ri] = {
                rule:sub(1, pos-1),  -- category
                rule:sub(pos, pos),  -- comparator
                tonumber(rule:sub(pos+1, s-1)),  -- number to compare to
                rule:sub(s+1)  -- target work flow
            }
        else  -- The rule demands to go straigth to another workflow.
            workflow[name][ri] = { rule }
        end
    end
end

local parts = {}  -- The parts are turned into ranges of length 1.
for i = startOfParts+1, #lines do
    parts[#parts+1] = { fate = "in" }
    for cat, rating in lines[i]:gmatch("([xmas])=(%d*)") do
        parts[#parts][cat] = { tonumber(rating), tonumber(rating) }
    end
end

-- solution of first part
local acceptedSingle = GetAcceptedRanges(workflow, parts, true)
local sumRatings = 0
for _, range in ipairs(acceptedSingle) do
    sumRatings = sumRatings + range.x[2] + range.m[2] + range.a[2] + range.s[2]
end
print(("Die Bewertung der angenommenen Teile betraegt %d."):format(sumRatings))

-- solution of second part
local acceptedRanges = GetAcceptedRanges(workflow)
local sumRanges = 0
for _, range in ipairs(acceptedRanges) do
    sumRanges = sumRanges + (range.x[2] - range.x[1] + 1) * (range.m[2] - range.m[1] + 1) * (range.a[2] - range.a[1] + 1) * (range.s[2] - range.s[1] + 1)
end
print(("Es gibt insgesamt %d Kombinationen, die angenommen werden."):format(sumRanges))