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

function string.count(s, comp)
    comp = comp or "."
    local counts = {}
    for c in s:gmatch(comp) do
        counts[c] = (counts[c] or 0) + 1
    end
    return counts
end

function table.count(t)
    local counts = {}
    for _, v in pairs(t) do
        counts[v] = (counts[v] or 0) + 1
    end
    return counts
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
    return ( m ~= 0 and n ~= 0 ) and m * n / gcd( m, n ) or 0
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