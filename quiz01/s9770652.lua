function GetLineNumber(line, textToNumber)
    if textToNumber then
        line = line
            :gsub("one", "o1e")
            :gsub("two", "t2")
            :gsub("three", "t3e")
            :gsub("four", "4")
            :gsub("five", "5e")
            :gsub("six", "6")
            :gsub("seven", "7n")
            :gsub("eight", "e8t")
            :gsub("nine", "n9e")
    end
    return tonumber(line:match("%d") .. line:match(".*(%d)"))
end

local sums = {0, 0}
for line in io.lines("s9770652.txt") do
    sums[1] = sums[1] + GetLineNumber(line)
    sums[2] = sums[2] + GetLineNumber(line, true)
end

print("Ohne Textkonvertierung betraegt die Summe " .. tostring(sums[1]) .. ".")
print("Mit Textkonvertierung betraegt die Summe " .. tostring(sums[2]) .. ".")