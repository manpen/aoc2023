dofile "..\\quiz01\\s9770652_commons.lua"

local CARDS = Enum{"2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"}

-- Returns a single digit representing the type of a hand.
-- The better the type, the higher the digit.
local function GetType(cards, wildcards)
    local labels = cards:count()  -- Count the occurrences of each label.
    local jokerCount = (wildcards and labels.J) or 0  -- 0 if no wildcards or no Jokers
    if jokerCount == 5 then  -- Return 'Five of a kind' prematurely.
        return 50
    end
    labels.J = (not wildcards or nil) and labels.J  -- Remove Jokers only if wildcards allowed.
    local tuples = table.collect(labels)  -- Boils `labels` neatly down to a series of numbers.
    table.sort(tuples)
    tuples[#tuples] = tuples[#tuples] + jokerCount  -- Turn Clown Prince of Crime into most common card.
    return tuples[#tuples] .. (tuples[#tuples-1] or 0)
end

-- Returns an array of tuples `{ hand, bid }`,
-- where `hand` is a numerical representation of the original cards.
-- The highest digit represents the type.
-- The better the original hand, the higher the numerical representation.
local function ConvertCards(hands, wildcards)
    local digits = EnumToStrings(CARDS)  -- Each card is turned into two digits.
    if wildcards then digits.J = "00" end
    local convertedHands = {}
    for i, hand in ipairs(hands) do
        local conv = GetType(hand[1], wildcards)
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