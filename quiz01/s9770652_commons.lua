function ReadAllLines(file)
    file = file or "s9770652.txt"
    local lines = {}
    local i = 0
    for line in io.lines"s9770652.txt" do
        i = i + 1
        lines[i] = line
    end
    return lines
end

function Enum(t)
    local enum = {}
    for k, v in ipairs(t) do
        enum[v] = k
    end
    return enum
end

function EnumToStrings(enum)
    local len = 0
    for _ in pairs(enum) do len = len + 1 end
    local formatter = "%0"..math.ceil(math.log(len+1, 10)).."d"
    local strings = {}
    for k, v in pairs(enum) do
        strings[k] = (formatter):format(v)
    end
    return strings
end

function string.totable(s, comp, method)
    comp = comp or "."
    method = method or function (c) return c end
    local t = {}
    local i = 0
    for c in s:gmatch(comp) do
        i = i + 1
        t[i] = method(c)
    end
    return t
end

function string.split(s, method)
    return s:totable("%S+", method)
end

function string.count(s, comp)
    comp = comp or "."
    local counts = {}
    for c in s:gmatch(comp) do
        counts[c] = (counts[c] or 0) + 1
    end
    return counts
end

function table.collect(t)
    local collection = {}
    local i = 0
    for _, v in pairs(t) do
        i = i + 1
        collection[i] = v
    end
    return collection
end

function table.count(t)
    local counts = {}
    for _, v in pairs(t) do
        counts[v] = (counts[v] or 0) + 1
    end
    return counts
end

function table.map(t, fn)
    local mapped = {}
    for k, v in pairs(t) do
        mapped[k] = fn(v)
    end
    return mapped
end

function table.maxv(t)
    local key, maxval = nil, -math.huge
    for k, v in pairs(t) do
        if v > maxval then
            maxval = v
            key = k
        end
    end
    return maxval, key
end

function table.sum(t)
    local sum = 0
    for _, v in ipairs(t) do
        sum = sum + v
    end
    return sum
end

function deepcopy(t)
    local copied = {}
    if type(t) == "table" then
        for k, v in pairs(t) do
            copied[k] = deepcopy(v)
        end
    else
        copied = t
    end
    return copied
end

-- taken from: https://rosettacode.org/wiki/Least_common_multiple#Lua
function gcd(m, n)
    while n ~= 0 do
        local q = m
        m = n
        n = q % n
    end
    return m
end

-- taken from: https://rosettacode.org/wiki/Least_common_multiple#Lua
function lcm(m, n)
    return ( m ~= 0 and n ~= 0 ) and m * n / gcd(m, n) or 0
end

-- taken from: https://stackoverflow.com/a/8695525
function table.reduce(list, fn, init)
    local acc = init
    for k, v in ipairs(list) do
        if 1 == k and not init then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end

-- taken from: https://stackoverflow.com/a/27028488
function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

------------------------
-- Matrix Operations. --
------------------------

-- Returns a table of matrices if multiple matrices are present, else only a matrix directly.
function FileToMatrix(file, comp, method)
    local lines = ReadAllLines(file)
    local matrices = { {} }
    local m = 1
    local row = 0
    for i = 1, #lines do
        if lines[i] == "" then
            m = m + 1
            row = 0
            matrices[m] = {}
        else
            row = row + 1
            matrices[m][row] = lines[i]:totable(comp, method)
        end
    end
    if #matrices == 1 then
        return matrices[1], #matrices[1], #matrices[1][1]
    end
    return matrices, #matrices[1], #matrices[1][1]
end

function PrintMatrix(matrix)
    local output = ""
    for row = 1, #matrix do
        output = output .. table.concat(matrix[row]) .. "\n"
    end
    print(output)
end

function RotateMatrix(matrix, rotation)
    assert(type(rotation) == "number", "Rotation is not a number!")
    local rot = {}
    local rows, cols = #matrix, #matrix[1]
    if rotation == 90 or rotation == -270 then
        for r = 1, cols do
            rot[r] = {}
            for c = 1, rows do
                rot[r][c] = matrix[rows-c+1][r]
            end
        end
    elseif rotation == 180 or rotation == -180 then
        for r = 1, rows do
            rot[r] = {}
            for c = 1, cols do
                rot[r][c] = matrix[rows-r+1][cols-c+1]
            end
        end
    elseif rotation == 270 or rotation == -90 then
        for r = 1, cols do
            rot[r] = {}
            for c = 1, rows do
                rot[r][c] = matrix[c][cols-r+1]
            end
        end
    elseif rotation == 0 or rotation == 360 then
        rot = matrix
    else
        assert(false, "Rotation is not one of the allowed values!")
    end
    return rot, #rot, #rot[1]
end

function TransposeMatrix(matrix)
    local transposed = {}
    local rows, cols = #matrix, #matrix[1]
    for r = 1, cols do
        transposed[r] = {}
        for c = 1, rows do
            transposed[r][c] = matrix[c][r]
        end
    end
    return transposed, #transposed, #transposed[1]
end

function CompareMatrices(matrix1, matrix2)
    local equal = true
    for r = 1, #matrix1 do
        for c = 1, #matrix1[1] do
            if matrix1[r][c] ~= matrix2[r][c] then
                equal = false
                break
            end
        end
        if not equal then break end
    end
    return equal
end