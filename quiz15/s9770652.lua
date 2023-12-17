dofile "..\\quiz01\\s9770652_commons.lua"

local function Hash(str)
    local s = 0
    for i = 1, #str do
        s = (s + str:byte(i)) * 17 % 256
    end
    return s
end

local sequence = ReadAllLines()[1]:totable("[^,]+")
local boxes = {}; for i = 1, 256 do boxes[i] = {} end
for _, step in ipairs(sequence) do
    local lbl, op, lens = step:match "(%a*)([-=])(%d?)"
    local box = Hash(lbl) + 1  -- The indices of boxes in the exercise start at 0. 
    if op == "-" then
        for i = 1, #boxes[box] do
            if boxes[box][i][2] == lbl then
                table.remove(boxes[box], i)
                break
            end
        end
    elseif op == "=" then
        local replaced = false
        for i = 1, #boxes[box] do
            if boxes[box][i][2] == lbl then
                boxes[box][i][1] = lens
                replaced = true
                break
            end
        end
        if not replaced then
            table.insert(boxes[box], { lens, lbl })
        end
    end
end
local focusingPower = 0
for box, lenses in ipairs(boxes) do
    for slot, lens in ipairs(lenses) do
        focusingPower = focusingPower + box * slot * lens[1]  -- no +1 for `box` needed due to one-based indexing
    end
end

print(("Die Summe der Hashes betraegt %d."):format(table.sum(table.map(sequence, Hash))))  -- solution of first part
print(("Die Fokalkraft betraegt %d."):format(focusingPower))  -- solution of second part