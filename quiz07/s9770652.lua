local TYPES = {
    FIVE_OF_A_KIND = 7,
    FOUR_OF_A_KIND = 6,
    FULL_HOUSE = 5,
    THREE_OF_A_KIND = 4,
    TWO_PAIR = 3,
    ONE_PAIR = 2,
    HIGH_CARD = 1
}

-- Returns a single digit representing the type of a hand.
-- The better the type, the higher the digit.
local function GetType(cards, wildcards)
    -- Count the occurrences of each label.
    local counts = {}
    for card in cards:gmatch"." do
        counts[card] = (counts[card] or 0) + 1
    end
    -- Count the occurrences of each tuple size.
    local freqs = {}
    for _, number in pairs(counts) do
        freqs[number] = (freqs[number] or 0) + 1
    end
    -- If wildcards are allowed, convert the Joker tuple into the next highest tuple.
    if wildcards and counts.J and not freqs[5] then  -- no need for conversion if no or only Clown Prince of Crime
        freqs[counts.J] = freqs[counts.J] - 1
        for i = 4, 1, -1 do
            if freqs[i] and freqs[i] > 0 then
                freqs[i+counts.J] = (freqs[i+counts.J] or 0) + 1
                freqs[i] = freqs[i] - 1
                break
            end
        end
    end
    -- Score the tuples.
    if freqs[5] then
        return TYPES.FIVE_OF_A_KIND
    elseif freqs[4] then
        return TYPES.FOUR_OF_A_KIND
    elseif freqs[3] and freqs[2] == 1 then  -- 0 counts as truthy in Lua :C
        return TYPES.FULL_HOUSE
    elseif freqs[3] then
        return TYPES.THREE_OF_A_KIND
    elseif freqs[2] == 2 then
        return TYPES.TWO_PAIR
    elseif freqs[2] == 1 then
        return TYPES.ONE_PAIR
    end
    return TYPES.HIGH_CARD
end

-- Returns an array of tuples `{ hand, bid }`,
-- where `hand` is a numerical representation of the original cards.
-- The highest digit represents the type.
-- The better the original hand, the higher the numerical representation.
local function ConvertCards(hands, wildcards)
    local p = {  -- Each card is turned into two digits.
        ["2"] = "01", ["3"] = "02", ["4"] = "03", ["5"] = "04", ["6"] = "05", ["7"] = "06", ["8"] = "07",
        ["9"] = "08", ["T"] = "09", ["J"] = "10", ["Q"] = "11", ["K"] = "12", ["A"] = "13"
    }
    if wildcards then p.J = "00" end
    local convertedHands = {}
    for i, hand in ipairs(hands) do
        local conv = GetType(hand[1], wildcards)
        for card in hand[1]:gmatch"." do
            conv = conv .. p[card]
        end
        convertedHands[i] = { conv, hand[2] }
    end
    return convertedHands
end

-- Converts the hands, sorts them, and returns the sum of winnings.
local function GetTotalWinning(hands, wildcards)
    local convertedHands = ConvertCards(hands, wildcards)
    table.sort(convertedHands, function (a, b) return a[1] < b[1] end)
    local winnings = 0
    for rank, hand in ipairs(convertedHands) do
        winnings = winnings + rank * hand[2]
    end
    return winnings
end

local hands = {}
for line in io.lines"s9770652.txt" do
    hands[#hands+1] = { line:match"(%w+) (%d+)" }
end

print(("Ohne Wildcards betraegt der Gesamtgewinn %d."):format(GetTotalWinning(hands, false)))  -- solution of first part
print(("Mit Wildcards betraegt der Gesamtgewinn %d."):format(GetTotalWinning(hands, true)))  -- solution of second part