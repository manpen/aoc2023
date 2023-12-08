dofile "..\\quiz01\\s9770652_commons.lua"

local TYPES = Enum{"HIGH_CARD", "ONE_PAIR", "TWO_PAIR", "THREE_OF_A_KIND", "FULL_HOUSE",
        "FOUR_OF_A_KIND", "FIVE_OF_A_KIND"}

-- Returns a single digit representing the type of a hand.
-- The better the type, the higher the digit.
local function GetType(cards, wildcards)
    local labels = cards:count()  -- Count the occurrences of each label.
    if wildcards and labels.J and labels.J < 5 then  -- no need for conversion if no or only Jokers
        local jokerCount = labels.J
        labels.J = nil
        local _, maxTuple = table.maxv(labels)  -- most common card (except for Clown Prince of Crime)
        labels[maxTuple] = labels[maxTuple] + jokerCount
    end
    local tuples = table.count(labels)  -- Count the occurrences of each tuple size.
    -- Score the tuples.
    if tuples[5] then
        return TYPES.FIVE_OF_A_KIND
    elseif tuples[4] then
        return TYPES.FOUR_OF_A_KIND
    elseif tuples[3] and tuples[2] then
        return TYPES.FULL_HOUSE
    elseif tuples[3] then
        return TYPES.THREE_OF_A_KIND
    elseif tuples[2] == 2 then
        return TYPES.TWO_PAIR
    elseif tuples[2] == 1 then
        return TYPES.ONE_PAIR
    end
    return TYPES.HIGH_CARD
end

-- Returns an array of tuples `{ hand, bid }`,
-- where `hand` is a numerical representation of the original cards.
-- The highest digit represents the type.
-- The better the original hand, the higher the numerical representation.
local function ConvertCards(hands, wildcards)
    local digits = EnumToStrings(Enum{  -- Each card is turned into two digits.
            "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"})
    if wildcards then digits.J = "00" end
    local convertedHands = {}
    for i, hand in ipairs(hands) do
        local conv = tostring(GetType(hand[1], wildcards))
        for card in hand[1]:gmatch"." do
            conv = conv .. digits[card]
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