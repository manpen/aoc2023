dofile "..\\quiz01\\s9770652_commons.lua"

function TestForSymmetries(m, targetDiffs)
    local rows, cols = #m, #m[1]
    local symRows, symCols = {}, {}
    -- Check for horizontal symmetries.
    for r = 1, rows - 1 do
        local diffs = 0
        local size = math.min(r, rows - r)  -- size of each reflection
        for mod = 1, size do
            for c = 1, cols do
                if m[r-mod+1][c] ~= m[r+mod][c] then
                    diffs = diffs + 1
                end
            end
        end
        if diffs == targetDiffs then
            symRows[#symRows+1] = r
        end
    end
    -- Check for vertical symmetries.
    for c = 1, cols - 1 do
        local diffs = 0
        local size = math.min(c, cols - c)  -- size of each reflection
        for mod = 1, size do
            for r = 1, rows do
                if m[r][c-mod+1] ~= m[r][c+mod] then
                    diffs = diffs + 1
                end
            end
        end
        if diffs == targetDiffs then
            symCols[#symCols+1] = c
        end
    end
    return symRows, symCols
end

local matrices = FileToMatrix()
local sum0, sum1 = 0, 0
for _, matrix in ipairs(matrices) do
    local rows, cols = TestForSymmetries(matrix, 0)
    sum0 = sum0 + table.sum(rows) * 100 + table.sum(cols)
    rows, cols = TestForSymmetries(matrix, 1)
    sum1 = sum1 + table.sum(rows) * 100 + table.sum(cols)
end
print(("Ohne Verschmutzung ist %d die Zusammenfassung."):format(sum0))  -- solution of first part
print(("Mit Verschmutzung ist %d die Zusammenfassung."):format(sum1))  -- solution of second part