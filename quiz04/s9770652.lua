local maxN = 0  -- how many unique cards there are
local copies = {}  -- how many cards of each number there are (including the originial)
local points = 0  -- sum of points (first part)
local cards = 0  -- sum of scratch cards (second part)
for line in io.lines("s9770652.txt") do
    -- Analyse the current scratch card.
    local colon, _ = line:find(":")  -- The colon separates winning cards from the card name.
    local pipe, _ = line:find("|")  -- The pipe character separates winning cards from actual ones.
    local winning = {}
    for i in line:sub(colon, pipe):gmatch("(%d+)") do
        winning[i] = true
    end
    local luckyNumbers = 0
    for i in line:sub(pipe):gmatch("(%d+)") do
        if winning[i] then
            luckyNumbers = luckyNumbers + 1
        end
    end
    -- Score the current scratch card.
    maxN = maxN + 1
    copies[maxN] = (copies[maxN] or 0) + 1
    cards = cards + copies[maxN]
    if luckyNumbers > 0 then
        points = points + 2^(luckyNumbers-1)
        for i = maxN + 1, maxN + luckyNumbers do
            copies[i] = (copies[i] or 0) + copies[maxN]
        end
    end
end

print(("Die Summe aller Punkte betraegt %d."):format(points))  -- solution of first part
print(("Die Anzahl aller Karten betraegt %d."):format(cards))  -- solution of second part