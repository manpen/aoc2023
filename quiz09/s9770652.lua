dofile "..\\quiz01\\s9770652_commons.lua"

local lines = ReadAllLines()
local extrapolation = { 0, 0 }
for _, line in ipairs(lines) do
    local numbers = { line:split(tonumber) }
    local i = 1
    local allZeroes
    repeat
        allZeroes = true
        i = i + 1
        numbers[i] = {}
        for j = 1, #numbers[i-1] - 1 do
            numbers[i][j] = numbers[i-1][j+1] - numbers[i-1][j]
            allZeroes = allZeroes and numbers[i][j] == 0
        end
    until allZeroes
    -- Extrapolation into the future.
    for j = #numbers-1, 1, -1 do
        extrapolation[1] = extrapolation[1] + numbers[j][#numbers[j]]
    end
    -- Extrapolation into the past.
    local newBackwardExtrapolation = 0
    for j = #numbers-1, 1, -1 do
        newBackwardExtrapolation = numbers[j][1] - newBackwardExtrapolation
    end
    extrapolation[2] = extrapolation[2] + newBackwardExtrapolation
end
print(("Die Summe der Extrapolationen in die Zukunft betraegt %d."):format(extrapolation[1]))  -- solution of first part
print(("Die Summe der Extrapolationen in die Vergangenheit betraegt %d."):format(extrapolation[2]))  -- solution of second part